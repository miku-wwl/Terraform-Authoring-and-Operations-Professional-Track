# Lab 121 知识点总结：
# - Lab 120 学对象职责；Lab 121 学在 HCP Terraform 中创建这些对象并选择 workspace workflow。
# - 新 organization 通常提供 Default Project，也可以创建按团队/业务划分的自定义 project。
# - 创建 workspace 时要选择所属 project，并决定配置来源与 run 触发方式。
# - VCS-driven：代码来自 Git，commit/PR 可以触发 plan，适合以仓库为 source of truth 的团队。
# - CLI-driven：保留本地 Terraform CLI 操作习惯，但 plan/apply 可在 HCP Terraform 远程执行。
# - API-driven：由外部自动化上传配置并控制 run，适合自定义平台或现有 CI/CD 集成。
# - 创建空 workspace 不等于已经连接 Git、配置变量、设置凭证或准备好 apply。
# - Workspace 上线前还要考虑 Terraform 版本、变量/凭证、权限、执行模式和审批设置。
# - Private registry 用于组织内共享 modules/providers，不是存放 workspace state 的位置。
# - UI 按钮和套餐限制会变化；考试重点是创建依赖和 workflow 选择，而不是点击路径。
#
# 本 Lab 不连接真实 HCP Terraform。请完成四组创建与场景判断。
# 每个 TODO 都提供可直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：排列从 organization 到 workspace 的概念创建顺序。
  # 答案级 Hint：直接使用下面的完整列表：
  # creation_sequence = [
  #   "create_organization",
  #   "use_default_or_create_project",
  #   "create_workspace_in_project",
  #   "select_workspace_workflow",
  #   "configure_workspace_before_first_run",
  # ]
  creation_sequence = []

  # TODO 2：根据团队场景选择 workspace workflow。
  # 答案级 Hint：完整答案如下：
  # workflow_selection = {
  #   git_pr_is_source_of_truth       = "vcs_driven"
  #   engineer_uses_local_cli         = "cli_driven"
  #   internal_platform_uploads_code  = "api_driven"
  # }
  workflow_selection = {
    git_pr_is_source_of_truth      = "api_driven"
    engineer_uses_local_cli        = "vcs_driven"
    internal_platform_uploads_code = "manual_only"
  }

  # TODO 3：列出 workspace 第一次正式 run 前的检查项。
  # 答案级 Hint：直接用下面列表替换空列表：
  # workspace_readiness = [
  #   "project_and_name",
  #   "workflow_and_configuration_source",
  #   "terraform_version_and_execution_mode",
  #   "variables_and_credentials",
  #   "team_permissions",
  #   "auto_apply_and_policy_settings",
  # ]
  workspace_readiness = []

  # TODO 4：判断 registry、settings 和 workspace 的职责。
  # 答案级 Hint：完整答案如下：
  # platform_capabilities = {
  #   private_registry      = "share_private_modules_and_providers"
  #   organization_settings = "users_teams_plan_and_billing"
  #   workspace             = "configuration_state_variables_and_runs"
  #   empty_workspace_ready_for_apply = false
  # }
  platform_capabilities = {
    private_registry                = "store_workspace_state"
    organization_settings           = "provider_resource_configuration"
    workspace                       = "billing_only"
    empty_workspace_ready_for_apply = true
  }
}

output "creation_sequence" {
  description = "Conceptual object creation and workspace setup sequence."
  value       = local.creation_sequence
}

output "workflow_selection" {
  description = "Workspace workflow selected for each operating model."
  value       = local.workflow_selection
}

output "workspace_readiness" {
  description = "Checks required before the first production-oriented run."
  value       = local.workspace_readiness
}

output "platform_capabilities" {
  description = "Responsibilities of registry, organization settings, and workspace."
  value       = local.platform_capabilities
}
