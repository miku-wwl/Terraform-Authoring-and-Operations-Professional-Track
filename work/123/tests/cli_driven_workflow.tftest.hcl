run "hcp_cli_driven_workflow_concepts_are_understood" {
  command = plan

  assert {
    condition = output.workflow_choices == {
      local_cli_starts_remote_runs = "cli_driven"
      git_pr_is_source_of_truth    = "vcs_driven"
      custom_platform_calls_api    = "api_driven"
      cli_driven_requires_git      = false
    }
    error_message = "Review TODO 1: select CLI-, VCS-, or API-driven according to the source and trigger."
  }

  assert {
    condition = output.authentication_boundaries == {
      cloud_block             = "link_directory_to_organization_and_workspace"
      terraform_login         = "authenticate_local_cli_to_hcp_terraform"
      provider_auth           = "authenticate_remote_run_to_cloud_provider"
      preferred_provider_auth = "oidc_dynamic_credentials"
    }
    error_message = "Review TODO 2: cloud block, CLI login, and remote provider authentication have separate responsibilities."
  }

  assert {
    condition = output.command_behaviors == {
      terraform_plan    = "upload_local_config_and_start_remote_speculative_plan"
      terraform_apply   = "start_remote_standard_run_for_non_vcs_workspace"
      terraform_destroy = "start_remote_destroy_run"
      output_location   = "remote_logs_streamed_to_local_terminal"
      state_location    = "hcp_terraform_workspace"
    }
    error_message = "Review TODO 3: commands start remote runs, stream logs locally, and keep state in HCP Terraform."
  }

  assert {
    condition = output.workspace_readiness == {
      workspace_object_exists       = true
      variables_auto_configured     = false
      provider_auth_auto_configured = false
      permissions_need_review       = true
      terraform_version_need_review = true
      ready_for_production_apply    = false
    }
    error_message = "Review TODO 4: an implicitly created workspace still needs variables, credentials, permissions, and version review."
  }
}
