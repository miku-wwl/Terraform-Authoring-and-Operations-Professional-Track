# Lab 119 知识点总结：
# - HCP Terraform 托管服务入口是 https://app.terraform.io。
# - 当前可以使用 HCP account 登录；旧的独立 HCP Terraform account 资料仍可能出现。
# - User account 表示个人身份；organization 是团队协作、权限、资源与计费边界。
# - 一个用户可以属于多个 organization，每个 organization 可以有不同套餐和权限。
# - Organization 包含 project，project 再组织 workspace/Stack；workspace 管理一组基础设施。
# - 创建账号和验证邮箱只是身份初始化，不会自动配置 workspace、remote state 或 cloud credentials。
# - 真正开始远程工作流还需要创建/加入 organization，并配置 project/workspace 和 workflow。
# - 不要把真实密码、邮箱验证链接或 API token 写入 .tf、output、测试或 Git。
# - API token 权限与对应身份相关，应使用尽可能短的有效期并安全保存。
# - 网页按钮和注册字段可能变化；考试应理解对象关系和安全边界，而不是死记 UI。
#
# 本 Lab 不强制注册外部账号。请完成四组概念判断；每个 TODO 都有完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：排列 HCP Terraform 的主要对象层级。
  # 答案级 Hint：直接用下面这行替换空列表：
  # object_hierarchy = ["user_account", "organization", "project", "workspace"]
  # 注意：user 可以加入多个 organization，因此这里表达的是学习路径，不是唯一所有权树。
  object_hierarchy = []

  # TODO 2：判断“只完成注册”以后已经具备什么。
  # 答案级 Hint：完整答案如下：
  # signup_facts = {
  #   personal_identity_exists  = true
  #   remote_state_ready        = false
  #   workspace_already_exists  = false
  #   cloud_credentials_ready   = false
  #   can_join_multiple_orgs    = true
  # }
  signup_facts = {
    personal_identity_exists = false
    remote_state_ready       = true
    workspace_already_exists = true
    cloud_credentials_ready  = true
    can_join_multiple_orgs   = false
  }

  # TODO 3：排列从注册到可运行 workspace 的概念步骤。
  # 答案级 Hint：直接使用下面的完整列表：
  # onboarding_sequence = [
  #   "open_hcp_terraform",
  #   "create_or_link_account",
  #   "verify_identity",
  #   "create_or_join_organization",
  #   "create_project_or_use_default",
  #   "create_and_configure_workspace",
  # ]
  onboarding_sequence = []

  # TODO 4：判断账号与 token 的安全做法。
  # 答案级 Hint：完整答案如下：
  # security_practices = {
  #   commit_password_to_git       = false
  #   output_api_token             = false
  #   use_short_token_expiration   = true
  #   enable_strong_authentication = true
  #   redact_verification_links    = true
  # }
  security_practices = {
    commit_password_to_git       = true
    output_api_token             = true
    use_short_token_expiration   = false
    enable_strong_authentication = false
    redact_verification_links    = false
  }
}

output "object_hierarchy" {
  description = "Learning sequence from user identity to infrastructure workspace."
  value       = local.object_hierarchy
}

output "signup_facts" {
  description = "What account registration does and does not configure."
  value       = local.signup_facts
}

output "onboarding_sequence" {
  description = "Conceptual onboarding sequence for HCP Terraform."
  value       = local.onboarding_sequence
}

output "security_practices" {
  description = "Safe account and API token handling decisions."
  value       = local.security_practices
}
