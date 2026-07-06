run "terraform_professional_mcq_pointers_are_correct" {
  command = plan

  assert {
    condition     = sort(output.hcp_concepts) == ["organization", "project", "workspace"]
    error_message = "hcp_concepts must include organization, project, and workspace."
  }

  assert {
    condition     = output.organization_capabilities == ["projects", "workspaces", "teams"]
    error_message = "organization_capabilities must describe organization as a shared space for projects, workspaces, and teams."
  }

  assert {
    condition     = output.workspace_features == ["git_repository", "workspace_variables", "configuration_code"]
    error_message = "workspace_features must include git repository, workspace variables, and configuration code."
  }

  assert {
    condition     = output.project_purpose == "organize_workspaces_and_assign_permissions"
    error_message = "project_purpose must describe organizing workspaces and assigning permissions."
  }

  assert {
    condition     = output.policy_set_targets == ["global", "project", "workspace"]
    error_message = "policy_set_targets must include global, project, and workspace."
  }

  assert {
    condition     = output.policy_set_direct_team_attachment == false
    error_message = "policy sets are not directly attached at team level."
  }

  assert {
    condition     = output.variable_set_scopes == ["global", "project", "workspace"]
    error_message = "variable_set_scopes must include global, project, and workspace."
  }

  assert {
    condition     = output.variable_categories == ["terraform", "environment"]
    error_message = "variable_categories must include terraform and environment."
  }

  assert {
    condition     = output.effective_db_write_capacity == 15
    error_message = "workspace variable with the same key must override the variable set value, producing 15."
  }

  assert {
    condition     = output.effective_variable_source == "workspace_variable"
    error_message = "effective_variable_source must be workspace_variable when the workspace override key matches."
  }

  assert {
    condition     = output.vault_secrets_plaintext_in_state == true
    error_message = "Vault provider secrets fetched into Terraform can remain plaintext in state."
  }

  assert {
    condition     = output.saved_plan_commands == ["terraform plan -out=ec2.plan", "terraform apply ec2.plan"]
    error_message = "saved_plan_commands must show saving a plan file and applying that saved plan file."
  }

  assert {
    condition     = output.hcp_workspace_outputs_data_source == "tfe_outputs"
    error_message = "HCP Terraform workspace outputs should use tfe_outputs for this pointer."
  }

  assert {
    condition     = output.run_trigger_behavior == "queue_destination_after_successful_apply_in_source_workspace"
    error_message = "run_trigger_behavior must describe queuing destination workspace runs after successful source workspace apply."
  }

  assert {
    condition     = output.run_task_stages == ["pre-plan", "post-plan", "pre-apply", "post-apply"]
    error_message = "run_task_stages must include pre-plan, post-plan, pre-apply, and post-apply."
  }

  assert {
    condition     = output.check_block_failure_behavior == "non_blocking_warning"
    error_message = "check block failures should be modeled as non-blocking warnings for this lab."
  }

  assert {
    condition     = output.cli_flags_for_automation == ["-input=false", "-no-color"]
    error_message = "cli_flags_for_automation must include -input=false and -no-color."
  }

  assert {
    condition     = output.vcs_trigger_troubleshooting_reason == "commit_does_not_match_configured_branch_or_tag_trigger"
    error_message = "VCS troubleshooting reason must identify branch/tag trigger mismatch."
  }
}
