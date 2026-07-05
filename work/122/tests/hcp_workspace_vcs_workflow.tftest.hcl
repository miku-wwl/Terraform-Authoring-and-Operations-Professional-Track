run "hcp_workspace_vcs_workflow_is_modeled" {
  command = plan

  assert {
    condition     = output.organization_name == "example-kplabs-org"
    error_message = "organization_name must be read from data/workspaces.json."
  }

  assert {
    condition     = output.workspace_count == 2
    error_message = "workspace_count must count all workspaces from the decoded JSON data."
  }

  assert {
    condition     = output.vcs_workspace_names == ["kplabs-terraform-learning"]
    error_message = "vcs_workspace_names must include only workspaces where workflow is vcs."
  }

  assert {
    condition     = output.workspace_repository == "demo-kplabs-user/kplabs-terraform-learning"
    error_message = "workspace_repository must come from the selected VCS workspace."
  }

  assert {
    condition = output.aws_env_variable_keys == [
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY",
      "AWS_REGION"
    ]
    error_message = "aws_env_variable_keys must include only variables where category is env, preserving JSON order."
  }

  assert {
    condition = output.sensitive_env_variable_keys == [
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY"
    ]
    error_message = "sensitive_env_variable_keys must include only sensitive environment variables."
  }

  assert {
    condition = output.run_summary_labels == [
      "plan:planned_and_finished",
      "apply:manual_confirmation_required",
      "final:discarded"
    ]
    error_message = "run_summary_labels must summarize plan, apply, and final run action from latest_run."
  }
}
