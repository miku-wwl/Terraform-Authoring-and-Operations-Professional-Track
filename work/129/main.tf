# Lab 129 知识点总结：
# - Lab 128 学 Team 与成员；Lab 129 学 Team 在 workspace 中具体可以做什么。
# - Workspace 预设角色按能力递增：Read → Plan → Write → Admin。
# - Read 可以查看 runs、variables、完整 state；它不只是“看一眼 workspace 名称”。
# - Plan 在 Read 基础上允许发起 plan，但不能 apply，也不能写 variables/state。
# - Write 适合日常基础设施维护，可 plan/apply、读写 variables/state、锁定 workspace 和下载 Sentinel mocks。
# - Admin 拥有最高 workspace 权限，还能修改设置、管理可见 Team 的访问并删除 workspace。
# - Custom role 用来组合任务需要的细粒度权限，但不能包含 Admin-only 权限。
# - Run 权限应区分 read、plan、apply；能 plan 不代表能 apply。
# - Variable 权限应区分 no access、read、read and write；Sensitive 值即使有 read 权限也不可再次查看。
# - State 权限应区分 no access、read outputs only、read、read and write。
# - Read outputs only 只允许访问显式公开的 root outputs；Read 可以下载完整 state。
# - 完整 state 可能包含资源属性和敏感信息，应比 outputs-only 更严格地授权。
# - State read and write 可创建 state versions，并用于 Local mode、import/taint/state 等维护操作。
# - Sentinel mocks 可能包含未脱敏敏感数据，下载权限不能随便授予。
# - Manage Workspace Run Tasks 允许关联外部服务；Run Tasks 可能接触 run 数据，应限制管理者和信任范围。
# - 权限来自 organization、project、workspace 和多个 Team 时会叠加，最终使用可获得的最高权限。
# - UI/API 中限制 state 读取，并不能阻止获得上传配置和发起 run 能力的人让 Terraform 在 run 中读取 state。
#
# 本 Lab 是概念、选择与判断题，不连接 HCP Terraform，也不模拟 Permission JSON 数据。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：为典型职责选择预设或 Custom workspace role。
  # 答案级 Hint：完整答案如下：
  # role_choices = {
  #   view_workspace_information  = "read"
  #   propose_without_apply       = "plan"
  #   daily_plan_and_apply        = "write"
  #   manage_settings_and_access  = "admin"
  #   task_specific_permissions   = "custom"
  # }
  role_choices = {
    view_workspace_information = "admin"
    propose_without_apply      = "write"
    daily_plan_and_apply       = "plan"
    manage_settings_and_access = "read"
    task_specific_permissions  = "owners"
  }

  # TODO 2：判断 Read、Plan、Write、Admin 的关键能力。
  # 答案级 Hint：完整答案如下：
  # role_capabilities = {
  #   read_can_plan             = false
  #   plan_can_plan             = true
  #   plan_can_apply            = false
  #   write_can_apply           = true
  #   write_can_manage_settings = false
  #   admin_can_delete_workspace = true
  # }
  role_capabilities = {
    read_can_plan              = true
    plan_can_plan              = false
    plan_can_apply             = true
    write_can_apply            = false
    write_can_manage_settings  = true
    admin_can_delete_workspace = false
  }

  # TODO 3：判断 outputs、完整 state 与 state write 的边界。
  # 答案级 Hint：完整答案如下：
  # state_judgements = {
  #   outputs_only_reads       = "public_root_outputs"
  #   full_state_permission    = "read"
  #   create_state_versions    = "read_and_write"
  #   state_may_contain_secrets = true
  #   plan_preset_reads_state  = true
  #   state_cli_maintenance    = "read_and_write"
  # }
  state_judgements = {
    outputs_only_reads        = "complete_state_file"
    full_state_permission     = "outputs_only"
    create_state_versions     = "read"
    state_may_contain_secrets = false
    plan_preset_reads_state   = false
    state_cli_maintenance     = "no_access"
  }

  # TODO 4：为细粒度权限和敏感数据场景选择正确做法。
  # 答案级 Hint：完整答案如下：
  # security_scenarios = {
  #   auditor_runs_no_full_state = "custom_role"
  #   sensitive_variable_read    = "value_remains_write_only"
  #   download_sentinel_mocks    = "treat_as_sensitive_access"
  #   attach_workspace_run_task  = "manage_workspace_run_tasks"
  #   custom_can_delete_workspace = false
  #   reduce_excess_access       = "review_all_additive_grants"
  # }
  security_scenarios = {
    auditor_runs_no_full_state  = "read_role"
    sensitive_variable_read     = "show_plaintext_value"
    download_sentinel_mocks     = "safe_for_every_user"
    attach_workspace_run_task   = "read_outputs_only"
    custom_can_delete_workspace = true
    reduce_excess_access        = "add_lower_permission_team"
  }
}

output "role_choices" {
  description = "Workspace role selected for each responsibility."
  value       = local.role_choices
}

output "role_capabilities" {
  description = "Key capabilities of Read, Plan, Write, and Admin roles."
  value       = local.role_capabilities
}

output "state_judgements" {
  description = "Boundaries between outputs-only, full-state, and state-write access."
  value       = local.state_judgements
}

output "security_scenarios" {
  description = "Fine-grained permission and sensitive-data scenario decisions."
  value       = local.security_scenarios
}
