# Lab 124 知识点总结：
# - Lab 123 学 CLI-driven workflow 的定位；Lab 124 学步骤顺序、各步骤职责和故障定位。
# - 典型顺序是：准备 workspace/cloud target → terraform login → terraform init → plan/apply。
# - cloud block 指定 organization 和 workspace，解决“连接到哪里”。
# - terraform login 获取并保存 HCP Terraform CLI 凭据，解决“本地 CLI 是谁”。
# - terraform init 初始化 cloud integration；修改 cloud block 后应重新运行 init。
# - terraform plan 从本地发起远端 speculative plan，不会直接 apply。
# - terraform apply 对未连接 VCS 的 workspace 发起远端 standard plan/apply。
# - 登录 token 与云 provider credentials 是两种不同凭据，不能互相替代。
# - 凭据文件和 token 不应进入 Git；token 应使用短有效期并按需撤销。
# - 判断远端执行应优先看 HCP run URL、workspace run history 和 remote execution 设置。
# - 本地/远端 Terraform 版本不同可以作为辅助证据，但版本相同不代表 run 在本地执行。
# - 创建或初始化成功不等于 workspace 已有变量、provider 认证、权限和生产安全设置。
#
# 本 Lab 是概念与故障判断题，不执行 terraform login，也不连接真实 HCP Terraform。
# 请完成四组判断；每个 TODO 都有完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：排列 CLI-driven workflow 的概念步骤。
  # 答案级 Hint：直接使用下面的完整列表：
  # workflow_sequence = [
  #   "configure_cloud_target",
  #   "terraform_login",
  #   "terraform_init",
  #   "terraform_plan",
  #   "terraform_apply_if_approved",
  # ]
  workflow_sequence = [
    "configure_cloud_target",
    "terraform_login",
    "terraform_init",
    "terraform_plan",
    "terraform_apply_if_approved",
  ]

  # TODO 2：为 cloud/login/init/plan 匹配职责。
  # 答案级 Hint：完整答案如下：
  # step_responsibilities = {
  #   cloud_block     = "select_organization_and_workspace"
  #   terraform_login = "authenticate_local_cli_to_hcp"
  #   terraform_init  = "initialize_or_reconfigure_cloud_integration"
  #   terraform_plan  = "start_remote_speculative_plan"
  #   terraform_apply = "start_remote_standard_run_for_non_vcs_workspace"
  # }
  step_responsibilities = {
    cloud_block     = "select_organization_and_workspace"
    terraform_login = "authenticate_local_cli_to_hcp"
    terraform_init  = "initialize_or_reconfigure_cloud_integration"
    terraform_plan  = "start_remote_speculative_plan"
    terraform_apply = "start_remote_standard_run_for_non_vcs_workspace"
  }

  # TODO 3：根据报错或变化选择优先检查项。
  # 答案级 Hint：完整答案如下：
  # troubleshooting_choices = {
  #   missing_hcp_credentials      = "terraform_login_or_cli_credentials"
  #   wrong_remote_workspace       = "cloud_block_organization_and_workspace"
  #   cloud_block_recently_changed = "rerun_terraform_init"
  #   remote_provider_auth_failed  = "workspace_dynamic_provider_credentials"
  #   no_remote_run_visible        = "execution_mode_and_workspace_run_history"
  # }
  troubleshooting_choices = {
    missing_hcp_credentials      = "terraform_login_or_cli_credentials"
    wrong_remote_workspace       = "cloud_block_organization_and_workspace"
    cloud_block_recently_changed = "rerun_terraform_init"
    remote_provider_auth_failed  = "workspace_dynamic_provider_credentials"
    no_remote_run_visible        = "execution_mode_and_workspace_run_history"
  }

  # TODO 4：判断凭据和远端执行证据的安全做法。
  # 答案级 Hint：完整答案如下：
  # safety_and_evidence = {
  #   commit_cli_credentials_file = false
  #   put_token_in_tf_code        = false
  #   prefer_short_token_expiry   = true
  #   run_url_is_remote_evidence  = true
  #   version_difference_required = false
  #   local_aws_creds_auto_upload = false
  # }
  safety_and_evidence = {
    commit_cli_credentials_file = false
    put_token_in_tf_code        = false
    prefer_short_token_expiry   = true
    run_url_is_remote_evidence  = true
    version_difference_required = false
    local_aws_creds_auto_upload = false
  }
}

output "workflow_sequence" {
  description = "Ordered conceptual steps for CLI-driven workflow."
  value       = local.workflow_sequence
}

output "step_responsibilities" {
  description = "Responsibility of cloud block, login, init, plan, and apply."
  value       = local.step_responsibilities
}

output "troubleshooting_choices" {
  description = "First checks for common CLI-driven workflow failures."
  value       = local.troubleshooting_choices
}

output "safety_and_evidence" {
  description = "Credential safety and reliable remote-execution evidence."
  value       = local.safety_and_evidence
}
