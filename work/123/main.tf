# Lab 123 知识点总结：
# - HCP Terraform 常见 workflow 包括 VCS-driven、CLI-driven 和 API-driven。
# - CLI-driven 适合熟悉 Terraform CLI、希望从本地目录发起远端 run 的用户。
# - CLI-driven 不要求代码先提交到 Git；本地配置会在发起 run 时上传到 HCP Terraform。
# - terraform plan 在 CLI-driven 下启动远端 speculative plan，并把远端日志流回本地终端。
# - terraform apply 在未连接 VCS 的 workspace 中可启动远端 standard plan/apply。
# - cloud block 用来关联 organization 和 workspace；terraform login 让本地 CLI 登录 HCP Terraform。
# - terraform login 不负责 AWS/Azure/GCP 认证；远端 provider 认证属于 workspace/run 的职责。
# - 本地电脑已有 AWS 环境变量，不代表 HCP Terraform 远端 run 自动拥有这些凭证。
# - 远端 workspace 集中管理 state、variables、run history、policy 和执行设置。
# - 当前优先使用 OIDC dynamic provider credentials 和最小权限 role，避免长期管理员密钥。
# - 如果团队要求所有变更通过 Git PR 审批，VCS-driven 通常比 CLI-driven 更合适。
#
# 本 Lab 是概念与场景判断题，不连接 HCP Terraform，也不执行任何远端命令。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：根据团队场景选择 workflow。
  # 答案级 Hint：完整答案如下：
  # workflow_choices = {
  #   local_cli_starts_remote_runs = "cli_driven"
  #   git_pr_is_source_of_truth    = "vcs_driven"
  #   custom_platform_calls_api    = "api_driven"
  #   cli_driven_requires_git      = false
  # }
  workflow_choices = {
    local_cli_starts_remote_runs = "vcs_driven"
    git_pr_is_source_of_truth    = "cli_driven"
    custom_platform_calls_api    = "manual_only"
    cli_driven_requires_git      = true
  }

  # TODO 2：区分 cloud block、terraform login 和 provider 认证。
  # 答案级 Hint：完整答案如下：
  # authentication_boundaries = {
  #   cloud_block       = "link_directory_to_organization_and_workspace"
  #   terraform_login   = "authenticate_local_cli_to_hcp_terraform"
  #   provider_auth     = "authenticate_remote_run_to_cloud_provider"
  #   preferred_provider_auth = "oidc_dynamic_credentials"
  # }
  authentication_boundaries = {
    cloud_block             = "configure_aws_credentials"
    terraform_login         = "authenticate_remote_run_to_aws"
    provider_auth           = "authenticate_git_commit"
    preferred_provider_auth = "long_lived_admin_access_keys"
  }

  # TODO 3：判断 CLI-driven 命令的本地/远端行为。
  # 答案级 Hint：完整答案如下：
  # command_behaviors = {
  #   terraform_plan    = "upload_local_config_and_start_remote_speculative_plan"
  #   terraform_apply   = "start_remote_standard_run_for_non_vcs_workspace"
  #   terraform_destroy = "start_remote_destroy_run"
  #   output_location   = "remote_logs_streamed_to_local_terminal"
  #   state_location    = "hcp_terraform_workspace"
  # }
  command_behaviors = {
    terraform_plan    = "execute_only_on_local_laptop"
    terraform_apply   = "always_triggered_by_git"
    terraform_destroy = "delete_hcp_organization"
    output_location   = "local_log_file_only"
    state_location    = "local_terraform_tfstate"
  }

  # TODO 4：判断新建 CLI-driven workspace 是否已经准备就绪。
  # 答案级 Hint：完整答案如下：
  # workspace_readiness = {
  #   workspace_object_exists       = true
  #   variables_auto_configured     = false
  #   provider_auth_auto_configured = false
  #   permissions_need_review       = true
  #   terraform_version_need_review = true
  #   ready_for_production_apply    = false
  # }
  workspace_readiness = {
    workspace_object_exists       = false
    variables_auto_configured     = true
    provider_auth_auto_configured = true
    permissions_need_review       = false
    terraform_version_need_review = false
    ready_for_production_apply    = true
  }
}

output "workflow_choices" {
  description = "Workflow selected for local CLI, Git PR, and API scenarios."
  value       = local.workflow_choices
}

output "authentication_boundaries" {
  description = "Responsibilities of cloud block, CLI login, and provider authentication."
  value       = local.authentication_boundaries
}

output "command_behaviors" {
  description = "Local initiation and remote execution behavior of CLI-driven commands."
  value       = local.command_behaviors
}

output "workspace_readiness" {
  description = "What an implicitly created CLI-driven workspace still needs."
  value       = local.workspace_readiness
}
