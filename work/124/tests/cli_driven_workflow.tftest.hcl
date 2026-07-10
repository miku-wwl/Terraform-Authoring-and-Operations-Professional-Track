run "cli_driven_steps_and_troubleshooting_are_understood" {
  command = plan

  assert {
    condition = output.workflow_sequence == [
      "configure_cloud_target",
      "terraform_login",
      "terraform_init",
      "terraform_plan",
      "terraform_apply_if_approved"
    ]
    error_message = "Review TODO 1: configure the target, authenticate, initialize, then plan/apply."
  }

  assert {
    condition = output.step_responsibilities == {
      cloud_block     = "select_organization_and_workspace"
      terraform_login = "authenticate_local_cli_to_hcp"
      terraform_init  = "initialize_or_reconfigure_cloud_integration"
      terraform_plan  = "start_remote_speculative_plan"
      terraform_apply = "start_remote_standard_run_for_non_vcs_workspace"
    }
    error_message = "Review TODO 2: cloud target, login, init, plan, and apply have separate responsibilities."
  }

  assert {
    condition = output.troubleshooting_choices == {
      missing_hcp_credentials      = "terraform_login_or_cli_credentials"
      wrong_remote_workspace       = "cloud_block_organization_and_workspace"
      cloud_block_recently_changed = "rerun_terraform_init"
      remote_provider_auth_failed  = "workspace_dynamic_provider_credentials"
      no_remote_run_visible        = "execution_mode_and_workspace_run_history"
    }
    error_message = "Review TODO 3: choose the correct first check for authentication, targeting, init, provider, and run visibility issues."
  }

  assert {
    condition = output.safety_and_evidence == {
      commit_cli_credentials_file = false
      put_token_in_tf_code        = false
      prefer_short_token_expiry   = true
      run_url_is_remote_evidence  = true
      version_difference_required = false
      local_aws_creds_auto_upload = false
    }
    error_message = "Review TODO 4: protect tokens and use direct HCP run evidence; local cloud credentials are not automatically uploaded."
  }
}
