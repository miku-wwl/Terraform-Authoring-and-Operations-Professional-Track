# Lab 128 知识点总结：
# - HCP Terraform Team 是 organization 内的用户分组，用来按职责批量授予权限。
# - 用户属于个人账号；Team 负责授权。不要共享 owners 账号或个人 API token。
# - 用户需要先被邀请加入 organization，随后通过一个或多个 Team 获得实际访问能力。
# - 用户可以属于多个 organizations，也可以在同一 organization 中属于多个 Teams。
# - 权限可以在 organization、project 和 workspace 三个范围授予。
# - 有效权限是叠加的：来自多个 Team/范围的权限取能够授予的最高访问能力。
# - 给用户再加一个低权限 Team，不会抵消他从另一个 Team 获得的高权限。
# - Owners Team 拥有 organization 的最高权限，以及所有 workspace 和 Stack 的最高权限。
# - 普通开发者、审计员和临时外包人员不应为了方便直接加入 Owners Team。
# - 最后一名 Owners Team 成员不能直接离开 organization，必须先增加另一名 owner 或删除 organization。
# - 邀请或管理成员需要 organization owner 或具有 Manage Membership 权限的用户。
# - 用户可以没有 Team，但在加入 Team 获得权限前无法使用 organization 的 Terraform 功能。
# - 最小权限通常通过职责化 Team 加 project/workspace 范围权限实现，而不是逐个用户随意授权。
# - 审计人员只需查看 runs 时，应授予只读能力，而不是 plan/apply 或变量写权限。
# - Team token 继承 Team 的权限，应当按最小权限、最短有效期保护和轮换。
# - HCP Europe organization 使用 HCP Groups/roles 管理成员，不存在传统 Owners Team；本 Lab 聚焦标准 HCP Terraform organization。
#
# 本 Lab 是概念、选择与判断题，不连接 HCP Terraform，也不模拟 Team/Invitation JSON 数据。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：区分 User、Invitation、Team 和 Permission 的职责。
  # 答案级 Hint：完整答案如下：
  # membership_model = {
  #   user_account       = "individual_identity"
  #   invitation         = "join_organization"
  #   team               = "group_users_by_responsibility"
  #   permission         = "authorize_actions_on_scopes"
  #   multiple_teams     = true
  # }
  membership_model = {
    user_account   = "shared_department_login"
    invitation     = "grant_owners_access"
    team           = "terraform_provider"
    permission     = "email_delivery_setting"
    multiple_teams = false
  }

  # TODO 2：判断 Owners Team 的能力和使用边界。
  # 答案级 Hint：完整答案如下：
  # owners_judgements = {
  #   maximum_organization_access = true
  #   maximum_workspace_access    = true
  #   default_for_all_users       = false
  #   last_owner_can_leave        = false
  #   membership_should_be_small  = true
  # }
  owners_judgements = {
    maximum_organization_access = false
    maximum_workspace_access    = false
    default_for_all_users       = true
    last_owner_can_leave        = true
    membership_should_be_small  = false
  }

  # TODO 3：判断权限范围、叠加规则与最小权限。
  # 答案级 Hint：完整答案如下：
  # permission_judgements = {
  #   available_scopes                = "organization_project_workspace"
  #   multiple_grants_are_additive    = true
  #   effective_access_uses_highest   = true
  #   low_role_revokes_high_role      = false
  #   prefer_role_based_teams         = true
  #   read_only_auditor_can_apply     = false
  # }
  permission_judgements = {
    available_scopes              = "workspace_only"
    multiple_grants_are_additive  = false
    effective_access_uses_highest = false
    low_role_revokes_high_role    = true
    prefer_role_based_teams       = false
    read_only_auditor_can_apply   = true
  }

  # TODO 4：为企业成员管理场景选择正确做法。
  # 答案级 Hint：完整答案如下：
  # access_scenarios = {
  #   app_developer_one_project = "developer_team_with_project_scope"
  #   contractor_read_one_workspace = "read_only_team_with_workspace_scope"
  #   suspicious_excess_access  = "review_all_team_and_scope_grants"
  #   automation_identity       = "least_privilege_team_token"
  #   hcp_europe_membership     = "hcp_groups_and_roles"
  # }
  access_scenarios = {
    app_developer_one_project     = "owners_team"
    contractor_read_one_workspace = "shared_owner_account"
    suspicious_excess_access      = "add_another_read_only_team"
    automation_identity           = "personal_owner_token"
    hcp_europe_membership         = "traditional_owners_team_only"
  }
}

output "membership_model" {
  description = "Responsibilities of users, invitations, teams, and permissions."
  value       = local.membership_model
}

output "owners_judgements" {
  description = "Capabilities and safe membership practices for the Owners Team."
  value       = local.owners_judgements
}

output "permission_judgements" {
  description = "Permission scopes, additive access, and least-privilege judgements."
  value       = local.permission_judgements
}

output "access_scenarios" {
  description = "Recommended access design for common enterprise membership scenarios."
  value       = local.access_scenarios
}
