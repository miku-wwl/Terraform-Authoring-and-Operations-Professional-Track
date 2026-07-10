run "hcp_account_and_organization_boundaries_are_understood" {
  command = plan

  assert {
    condition = output.object_hierarchy == [
      "user_account",
      "organization",
      "project",
      "workspace"
    ]
    error_message = "Review TODO 1: follow the learning path from user identity through organization and project to workspace."
  }

  assert {
    condition = output.signup_facts == {
      personal_identity_exists = true
      remote_state_ready       = false
      workspace_already_exists = false
      cloud_credentials_ready  = false
      can_join_multiple_orgs   = true
    }
    error_message = "Review TODO 2: signup establishes identity but does not configure state, workspace, or cloud credentials."
  }

  assert {
    condition = output.onboarding_sequence == [
      "open_hcp_terraform",
      "create_or_link_account",
      "verify_identity",
      "create_or_join_organization",
      "create_project_or_use_default",
      "create_and_configure_workspace"
    ]
    error_message = "Review TODO 3: preserve the conceptual onboarding sequence from portal access to a configured workspace."
  }

  assert {
    condition = output.security_practices == {
      commit_password_to_git       = false
      output_api_token             = false
      use_short_token_expiration   = true
      enable_strong_authentication = true
      redact_verification_links    = true
    }
    error_message = "Review TODO 4: never commit passwords or output tokens; prefer short expiry, strong authentication, and redaction."
  }
}
