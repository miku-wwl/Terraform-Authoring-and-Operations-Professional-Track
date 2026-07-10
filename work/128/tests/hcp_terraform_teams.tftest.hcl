run "hcp_terraform_team_concepts_are_understood" {
  command = plan

  assert {
    condition = output.membership_model == {
      user_account   = "individual_identity"
      invitation     = "join_organization"
      team           = "group_users_by_responsibility"
      permission     = "authorize_actions_on_scopes"
      multiple_teams = true
    }
    error_message = "Review TODO 1: users are identities, invitations join organizations, teams group users, and permissions authorize actions."
  }

  assert {
    condition = output.owners_judgements == {
      maximum_organization_access = true
      maximum_workspace_access    = true
      default_for_all_users       = false
      last_owner_can_leave        = false
      membership_should_be_small  = true
    }
    error_message = "Review TODO 2: Owners have maximum access, so membership must remain limited and the last owner cannot leave."
  }

  assert {
    condition = output.permission_judgements == {
      available_scopes              = "organization_project_workspace"
      multiple_grants_are_additive  = true
      effective_access_uses_highest = true
      low_role_revokes_high_role    = false
      prefer_role_based_teams       = true
      read_only_auditor_can_apply   = false
    }
    error_message = "Review TODO 3: permissions are scoped and additive; a lower grant does not cancel a higher grant."
  }

  assert {
    condition = output.access_scenarios == {
      app_developer_one_project       = "developer_team_with_project_scope"
      contractor_read_one_workspace   = "read_only_team_with_workspace_scope"
      suspicious_excess_access        = "review_all_team_and_scope_grants"
      automation_identity             = "least_privilege_team_token"
      hcp_europe_membership           = "hcp_groups_and_roles"
    }
    error_message = "Review TODO 4: choose role-based least privilege and account for the HCP Europe group model."
  }
}
