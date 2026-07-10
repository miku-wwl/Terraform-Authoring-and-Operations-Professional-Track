# Lab 131 知识点总结：
# - State migration 是把同一批已管理资源的 state 存储位置迁移，不是重新创建或导入资源。
# - 迁移前必须停止针对该 state 的 Terraform/CI 操作，避免迁移期间出现并发写入。
# - 迁移前应制作独立、受保护的 state 备份；state 可能包含敏感数据，不能提交 Git。
# - 使用迁移前创建资源时所用的 Terraform CLI 版本，可降低 state format 被意外升级或损坏的风险。
# - HCP Terraform organization 必须已经存在；cloud block 指定 organization 与 workspace 目标。
# - 目标 workspace 可以由 init 隐式创建；如果使用现有 workspace，它不应已有 state。
# - terraform login 认证本地 CLI 到 HCP Terraform，不负责迁移，也不负责云 provider 认证。
# - 添加 cloud block 后运行 terraform init，Terraform 检测现有 state 并询问是否复制到 HCP workspace。
# - 正确顺序通常是：冻结写入 → 备份 state → 配置 cloud target → login → init 迁移 → 验证。
# - terraform init -migrate-state 会尝试复制 state，但根据变更情况仍可能出现确认提示。
# - terraform init -force-copy 会自动启用 -migrate-state，并对迁移确认回答 yes；自动化中风险更高。
# - terraform init -reconfigure 会忽略已有 backend 配置，并阻止迁移现有 state，不能当迁移替代品。
# - -ignore-remote-version 只针对会在本地修改并推送 remote state 的命令，官方建议除非绝对必要不要使用。
# - 远端版本检查的正确处理优先级是统一兼容版本，而不是默认绕过保护。
# - 迁移完成后先在 HCP Terraform States 页面验证 state/version，再运行 plan 检查不应重建资源。
# - Workspace variables 和 provider credentials 不会因为 state 迁移自动配置，必须另行准备。
# - 只有确认远端 state 正确、plan 合理和备份可恢复后，才清理遗留 local state 文件。
# - HCP Terraform 会保存 workspace state versions，但版本历史不能替代迁移前的独立备份和变更冻结。
#
# 本 Lab 是概念、选择与判断题，不连接 HCP Terraform，也不迁移任何真实 state。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：判断迁移前的安全准备。
  # 答案级 Hint：完整答案如下：
  # pre_migration_checks = {
  #   stop_state_writers       = true
  #   independent_backup       = true
  #   commit_backup_to_git     = false
  #   prefer_same_cli_version  = true
  #   existing_target_has_state = false
  # }
  pre_migration_checks = {
    stop_state_writers        = false
    independent_backup        = false
    commit_backup_to_git      = true
    prefer_same_cli_version   = false
    existing_target_has_state = true
  }

  # TODO 2：为 cloud block、login 和 init 匹配职责与顺序。
  # 答案级 Hint：完整答案如下：
  # migration_workflow = {
  #   cloud_block     = "select_hcp_organization_and_workspace"
  #   terraform_login = "authenticate_local_cli_to_hcp"
  #   terraform_init  = "initialize_cloud_and_offer_state_copy"
  #   safe_sequence   = "freeze_backup_cloud_login_init_verify"
  #   recreates_resources = false
  # }
  migration_workflow = {
    cloud_block         = "copy_state_immediately"
    terraform_login     = "authenticate_cloud_provider"
    terraform_init      = "destroy_and_recreate_resources"
    safe_sequence       = "delete_state_then_login"
    recreates_resources = true
  }

  # TODO 3：判断 init 迁移参数的真实行为。
  # 答案级 Hint：完整答案如下：
  # init_flag_judgements = {
  #   plain_init         = "interactive_migration_prompt"
  #   migrate_state      = "attempt_copy_may_still_prompt"
  #   force_copy         = "auto_yes_and_implies_migrate_state"
  #   reconfigure        = "discard_backend_history_without_migration"
  #   force_copy_default = false
  # }
  init_flag_judgements = {
    plain_init         = "never_detect_existing_state"
    migrate_state      = "guaranteed_noninteractive"
    force_copy         = "read_only_validation"
    reconfigure        = "safe_state_migration"
    force_copy_default = true
  }

  # TODO 4：判断迁移后的验证、配置和版本策略。
  # 答案级 Hint：完整答案如下：
  # post_migration_judgements = {
  #   verify_remote_state_first   = true
  #   plan_checks_for_recreation  = true
  #   variables_auto_migrated     = false
  #   credentials_auto_migrated   = false
  #   delete_local_before_verify  = false
  #   ignore_version_is_last_resort = true
  #   state_history_replaces_backup = false
  # }
  post_migration_judgements = {
    verify_remote_state_first     = false
    plan_checks_for_recreation    = false
    variables_auto_migrated       = true
    credentials_auto_migrated     = true
    delete_local_before_verify    = true
    ignore_version_is_last_resort = false
    state_history_replaces_backup = true
  }
}

output "pre_migration_checks" {
  description = "Safety checks required before migrating Terraform state."
  value       = local.pre_migration_checks
}

output "migration_workflow" {
  description = "Responsibilities and sequence for cloud, login, init, and verification."
  value       = local.migration_workflow
}

output "init_flag_judgements" {
  description = "Behavior of init migration, force-copy, and reconfigure flags."
  value       = local.init_flag_judgements
}

output "post_migration_judgements" {
  description = "Post-migration verification, workspace configuration, and version strategy."
  value       = local.post_migration_judgements
}
