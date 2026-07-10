# Lab 125 知识点总结：
# - Variable Set 是一组可复用变量，可应用到多个 HCP Terraform workspace 和 Stack。
# - Organization-owned Variable Set 可跨 project 分享；Project-owned Variable Set 只服务所属 project。
# - Organization-owned set 可全局应用，也可选择 project、workspace 或 Stack。
# - Project-owned set 可应用整个 project，或选择该 project 内的 workspace 和 Stack。
# - Global 或 project-wide 作用域会自动覆盖相应范围内当前及未来创建的 workspace。
# - Variable Set 中既能保存 Terraform variables，也能保存 environment variables。
# - Terraform variable 对应配置里的 var.<name>；environment variable 注入远端运行进程环境。
# - HCL 选项只适用于 Terraform variable；environment variable 的值按字符串处理。
# - 普通情况下，workspace-specific variable 会覆盖 Variable Set 中同类型、同 key 的变量。
# - 同 scope/ownership 的非 priority Variable Set 冲突时按名称的 Unicode 词法顺序决定，不看最后编辑时间。
# - Priority Variable Set 是例外：它可覆盖更具体作用域乃至 CLI run-specific 的同名变量。
# - Local execution mode 不会使用 HCP Terraform workspace variables 或 Variable Sets。
# - Sensitive 让变量值在 HCP Terraform UI/API 中不可再次读取，但不保证它永远不会进入日志或 state。
# - 变量 description 不加密，不能把秘密写进 description。
# - 云认证优先使用 dynamic provider credentials，避免在 Variable Set 中长期保存静态密钥。
# - 凭据类 Variable Set 应遵循最小作用域原则，不能因为“方便复用”就全局授权。
#
# 本 Lab 是概念、选择与判断题，不连接 HCP Terraform，也不模拟 Variable Set 数据处理。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：根据复用范围选择 Variable Set 的 ownership/scope。
  # 答案级 Hint：完整答案如下：
  # scope_choices = {
  #   share_across_projects       = "organization_owned"
  #   share_within_one_project    = "project_owned"
  #   all_org_current_and_future  = "global"
  #   selected_workspaces_only    = "workspace_scoped"
  #   reusable_across_workspaces  = true
  # }
  scope_choices = {
    share_across_projects      = "organization_owned"
    share_within_one_project   = "project_owned"
    all_org_current_and_future = "global"
    selected_workspaces_only   = "workspace_scoped"
    reusable_across_workspaces = true
  }

  # TODO 2：区分 Terraform variable 与 environment variable。
  # 答案级 Hint：完整答案如下：
  # variable_categories = {
  #   module_input_value       = "terraform"
  #   provider_process_setting = "environment"
  #   hcl_option_supported_by  = "terraform_only"
  #   sensitive_supported_by   = "both_categories"
  #   env_values_are_strings   = true
  # }
  variable_categories = {
    module_input_value       = "terraform"
    provider_process_setting = "environment"
    hcl_option_supported_by  = "terraform_only"
    sensitive_supported_by   = "both_categories"
    env_values_are_strings   = true
  }

  # TODO 3：判断普通优先级、Priority Variable Set 和执行模式。
  # 答案级 Hint：完整答案如下：
  # precedence_and_execution = {
  #   normal_same_key_winner       = "workspace_specific_variable"
  #   priority_set_can_override    = "more_specific_scopes_and_cli_values"
  #   overwritten_marker_location  = "workspace_variables_ui"
  #   local_execution_uses_varsets = false
  #   newest_edit_always_wins      = false
  # }
  precedence_and_execution = {
    normal_same_key_winner       = "workspace_specific_variable"
    priority_set_can_override    = "more_specific_scopes_and_cli_values"
    overwritten_marker_location  = "workspace_variables_ui"
    local_execution_uses_varsets = false
    newest_edit_always_wins      = false
  }

  # TODO 4：判断 sensitive、凭据和最小作用域的安全做法。
  # 答案级 Hint：完整答案如下：
  # security_judgements = {
  #   sensitive_is_write_only_in_ui_api = true
  #   sensitive_guarantees_no_state_leak = false
  #   descriptions_are_encrypted         = false
  #   prefer_dynamic_credentials          = true
  #   credentials_should_be_global        = false
  #   trace_logs_need_protection          = true
  # }
  security_judgements = {
    sensitive_is_write_only_in_ui_api  = true
    sensitive_guarantees_no_state_leak = false
    descriptions_are_encrypted         = false
    prefer_dynamic_credentials         = true
    credentials_should_be_global       = false
    trace_logs_need_protection         = true
  }
}

output "scope_choices" {
  description = "Variable Set ownership and scope selected for each reuse scenario."
  value       = local.scope_choices
}

output "variable_categories" {
  description = "Differences between Terraform and environment variable categories."
  value       = local.variable_categories
}

output "precedence_and_execution" {
  description = "Normal precedence, priority sets, and execution-mode behavior."
  value       = local.precedence_and_execution
}

output "security_judgements" {
  description = "Security judgements for sensitive values and provider credentials."
  value       = local.security_judgements
}
