run "workspace_creation_and_workflow_selection_are_understood" {
  command = plan

  assert {
    condition = output.creation_sequence == [
      "create_organization",
      "use_default_or_create_project",
      "create_workspace_in_project",
      "select_workspace_workflow",
      "configure_workspace_before_first_run"
    ]
    error_message = "Review TODO 1: create the hierarchy, select a workflow, then configure the workspace before its first run."
  }

  assert {
    condition = output.workflow_selection == {
      git_pr_is_source_of_truth      = "vcs_driven"
      engineer_uses_local_cli        = "cli_driven"
      internal_platform_uploads_code = "api_driven"
    }
    error_message = "Review TODO 2: select VCS-, CLI-, or API-driven according to the source of truth and run trigger."
  }

  assert {
    condition = output.workspace_readiness == [
      "project_and_name",
      "workflow_and_configuration_source",
      "terraform_version_and_execution_mode",
      "variables_and_credentials",
      "team_permissions",
      "auto_apply_and_policy_settings"
    ]
    error_message = "Review TODO 3: an empty workspace still needs source, version, variables, credentials, permissions, and run settings."
  }

  assert {
    condition = output.platform_capabilities == {
      private_registry                = "share_private_modules_and_providers"
      organization_settings           = "users_teams_plan_and_billing"
      workspace                       = "configuration_state_variables_and_runs"
      empty_workspace_ready_for_apply = false
    }
    error_message = "Review TODO 4: distinguish registry, organization settings, and workspace responsibilities."
  }
}
