# Lab 120 知识点总结：
# - HCP Terraform 的核心层级是 Organization → Project → Workspace / Stack。
# - Organization 是团队、套餐/计费和组织级设置边界；一个用户可以属于多个 organization。
# - Project 用来分组相关 workspace/Stack，并可作为团队访问控制边界。
# - Workspace 管理一套 Terraform 工作负载，关联配置、变量、state、run 历史和执行设置。
# - HCP Terraform workspace 类似独立 working directory，但不是 terraform workspace CLI 命令。
# - 本地工作流通常把配置放磁盘、变量放 tfvars/环境、state 放本地或自选 remote backend。
# - HCP remote workspace 将 state 和 workspace variables 集中保存，并记录 remote run 历史。
# - Workspace 可以连接 VCS，也可以通过 CLI-driven 或 API-driven workflow 接收配置。
# - VCS integration 很常见，但不是创建或使用 HCP Terraform workspace 的硬性要求。
# - Sensitive 标记可以隐藏变量显示，但真实云认证仍应优先考虑短期动态凭证。
#
# 本 Lab 不连接真实 HCP Terraform。请完成四组职责与场景判断。
# 每个 TODO 都提供可直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：为三个平台对象匹配主要职责。
  # 答案级 Hint：完整答案如下：
  # object_responsibilities = {
  #   organization = "teams_billing_and_org_settings"
  #   project      = "group_workspaces_and_scope_access"
  #   workspace    = "configuration_variables_state_and_runs"
  # }
  object_responsibilities = {
    organization = "single_terraform_state"
    project      = "provider_plugin_cache"
    workspace    = "organization_billing_only"
  }

  # TODO 2：比较本地 working directory 与 HCP remote workspace。
  # 答案级 Hint：可以直接参考下面整段：
  # storage_comparison = {
  #   local_configuration = "local_disk"
  #   hcp_configuration   = "vcs_or_cli_api_upload"
  #   local_variables     = "tfvars_cli_or_environment"
  #   hcp_variables       = "workspace_or_variable_sets"
  #   local_state         = "local_or_configured_backend"
  #   hcp_state           = "workspace_managed_state"
  #   hcp_run_history     = "workspace_run_history"
  # }
  storage_comparison = {}

  # TODO 3：为配置来源选择 HCP Terraform workflow。
  # 答案级 Hint：完整答案如下：
  # workflow_choices = {
  #   repository_commit_triggers_run = "vcs_driven"
  #   local_cli_starts_remote_run    = "cli_driven"
  #   automation_uploads_config      = "api_driven"
  #   vcs_is_mandatory               = false
  # }
  workflow_choices = {
    repository_commit_triggers_run = "cli_driven"
    local_cli_starts_remote_run    = "vcs_driven"
    automation_uploads_config      = "manual_only"
    vcs_is_mandatory               = true
  }

  # TODO 4：为一个 organization 设计 project/workspace 分组。
  # 答案级 Hint：可以直接参考下面整段：
  # organization_design = {
  #   network_project = ["network-dev", "network-prod"]
  #   app_project     = ["app-dev", "app-prod"]
  #   security_project = ["security-monitoring", "security-hardening"]
  # }
  organization_design = {}
}

output "object_responsibilities" {
  description = "Primary responsibility of organization, project, and workspace."
  value       = local.object_responsibilities
}

output "storage_comparison" {
  description = "Local working directory versus HCP remote workspace storage."
  value       = local.storage_comparison
}

output "workflow_choices" {
  description = "HCP Terraform configuration-source workflow choices."
  value       = local.workflow_choices
}

output "organization_design" {
  description = "Example projects and workspaces for three ownership domains."
  value       = local.organization_design
}
