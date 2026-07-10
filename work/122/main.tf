# Lab 122 知识点总结：
# - VCS-driven workspace 从连接的 Git 仓库取得 Terraform 配置，仓库通常作为 source of truth。
# - Workspace 要配置 repository、branch；monorepo 还要配置 working directory 和触发路径。
# - Pull request 通常触发 speculative plan：可以预览和检查，但这个 plan 不能直接 apply。
# - 向选定/default branch push 通常触发标准 run；manual apply 会在成功 plan 后等待确认。
# - 确认 apply 才会变更基础设施；discard run 不会执行 apply。
# - Auto apply 适合严格受控的自动化流程，生产环境不应在缺少保护时随意开启。
# - Monorepo 应用 working directory + trigger patterns，避免无关文件变化触发所有 workspace。
# - Workspace 保存变量、state、run 历史和设置，不只是一个 Git repository link。
# - 原视频使用长期 AWS access key + AdministratorAccess 只适合说明旧流程，不是现代安全范例。
# - 当前优先使用 OIDC dynamic provider credentials，为每次 run 获取短期、最小权限凭证。
# - Sensitive 标记可以隐藏 UI 显示，但不能把过度权限的长期密钥自动变安全。
#
# 本 Lab 不连接真实 HCP Terraform、GitHub 或 AWS。请完成四组 VCS workflow 判断。
# 每个 TODO 都有可直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：配置一个 monorepo 中的 production network workspace。
  # 答案级 Hint：完整答案如下：
  # vcs_workspace_settings = {
  #   repository        = "acme/infrastructure"
  #   branch            = "main"
  #   working_directory = "environments/prod/network"
  #   trigger_patterns  = ["/environments/prod/network/**/*.tf", "/modules/networking/**/*"]
  #   speculative_plans = true
  #   apply_method      = "manual"
  # }
  vcs_workspace_settings = {
    repository        = ""
    branch            = ""
    working_directory = ""
    trigger_patterns  = []
    speculative_plans = false
    apply_method      = "auto"
  }

  # TODO 2：判断不同 VCS 事件会产生什么结果。
  # 答案级 Hint：完整答案如下：
  # event_results = {
  #   pull_request_opened  = "speculative_plan_no_apply"
  #   push_to_main         = "standard_plan_wait_for_confirmation"
  #   confirm_apply        = "apply_infrastructure_changes"
  #   discard_run          = "no_apply_no_infrastructure_change"
  # }
  event_results = {
    pull_request_opened = "apply_immediately"
    push_to_main        = "no_run"
    confirm_apply       = "discard_run"
    discard_run         = "apply_changes"
  }

  # TODO 3：判断同一 monorepo 中 network/app 两套配置怎样隔离。
  # 答案级 Hint：完整答案如下：
  # monorepo_design = {
  #   workspace_count        = 2
  #   network_working_dir    = "network"
  #   app_working_dir        = "app"
  #   independent_state      = true
  #   path_filtered_triggers = true
  # }
  monorepo_design = {
    workspace_count        = 1
    network_working_dir    = "/"
    app_working_dir        = "/"
    independent_state      = false
    path_filtered_triggers = false
  }

  # TODO 4：选择 AWS remote run 的安全认证策略。
  # 答案级 Hint：完整答案如下：
  # credential_strategy = {
  #   preferred_method            = "oidc_dynamic_credentials"
  #   credential_lifetime         = "per_run_short_lived"
  #   permission_model            = "least_privilege_role"
  #   store_admin_access_keys     = false
  #   sensitive_flag_is_sufficient = false
  # }
  credential_strategy = {
    preferred_method             = "static_access_keys"
    credential_lifetime          = "long_lived"
    permission_model             = "administrator_access"
    store_admin_access_keys      = true
    sensitive_flag_is_sufficient = true
  }
}

output "vcs_workspace_settings" {
  description = "Repository, path triggers, speculative plan, and apply settings."
  value       = local.vcs_workspace_settings
}

output "event_results" {
  description = "Expected outcomes for pull request, push, confirm, and discard events."
  value       = local.event_results
}

output "monorepo_design" {
  description = "Workspace and state isolation for two configurations in one repository."
  value       = local.monorepo_design
}

output "credential_strategy" {
  description = "Secure AWS authentication strategy for HCP Terraform runs."
  value       = local.credential_strategy
}
