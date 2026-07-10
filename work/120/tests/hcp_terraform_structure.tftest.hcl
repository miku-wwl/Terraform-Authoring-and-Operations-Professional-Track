run "hcp_terraform_structure_is_understood" {
  command = plan

  assert {
    condition = output.object_responsibilities == {
      organization = "teams_billing_and_org_settings"
      project      = "group_workspaces_and_scope_access"
      workspace    = "configuration_variables_state_and_runs"
    }
    error_message = "Review TODO 1: match organization, project, and workspace to their primary responsibilities."
  }

  assert {
    condition = output.storage_comparison == {
      local_configuration = "local_disk"
      hcp_configuration   = "vcs_or_cli_api_upload"
      local_variables     = "tfvars_cli_or_environment"
      hcp_variables       = "workspace_or_variable_sets"
      local_state         = "local_or_configured_backend"
      hcp_state           = "workspace_managed_state"
      hcp_run_history     = "workspace_run_history"
    }
    error_message = "Review TODO 2: compare where configuration, variables, state, and run history live."
  }

  assert {
    condition = output.workflow_choices == {
      repository_commit_triggers_run = "vcs_driven"
      local_cli_starts_remote_run    = "cli_driven"
      automation_uploads_config      = "api_driven"
      vcs_is_mandatory               = false
    }
    error_message = "Review TODO 3: HCP Terraform supports VCS-, CLI-, and API-driven workflows; VCS is optional."
  }

  assert {
    condition = output.organization_design == {
      network_project  = ["network-dev", "network-prod"]
      app_project      = ["app-dev", "app-prod"]
      security_project = ["security-monitoring", "security-hardening"]
    }
    error_message = "Review TODO 4: group related dev/prod workspaces into ownership-oriented projects."
  }
}
