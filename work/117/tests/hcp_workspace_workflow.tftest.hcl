run "hcp_workspace_and_run_workflow_are_modeled_correctly" {
  command = plan

  assert {
    condition = output.workspace_summary == {
      organization     = "platform-engineering"
      project          = "networking"
      workspace        = "network-prod"
      terraform_version = "1.9.8"
      execution_mode   = "remote"
    }
    error_message = "workspace_summary must be built from the decoded HCP workspace mock data."
  }

  assert {
    condition     = output.vcs_source == "github:acme/network-infrastructure@main"
    error_message = "vcs_source must combine provider, repository, and branch."
  }

  assert {
    condition = output.run_phase_names == [
      "plan",
      "cost_estimation",
      "policy_check",
      "apply"
    ]
    error_message = "run_phase_names must preserve the phase order from the mock run."
  }

  assert {
    condition     = output.failed_policy_names == ["restrict-instance-types"]
    error_message = "failed_policy_names must include only policies whose status is failed."
  }

  assert {
    condition = output.sensitive_variable_keys == [
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY"
    ]
    error_message = "sensitive_variable_keys must include every variable marked sensitive."
  }

  assert {
    condition     = output.terraform_variable_keys == ["environment"]
    error_message = "terraform_variable_keys must select variables in the terraform category."
  }

  assert {
    condition = output.environment_variable_keys == [
      "AWS_REGION",
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY"
    ]
    error_message = "environment_variable_keys must select variables in the env category."
  }

  assert {
    condition     = output.run_blocked
    error_message = "run_blocked must be true when at least one policy failed."
  }

  assert {
    condition     = output.manual_approval_required
    error_message = "manual_approval_required must be true when auto_apply is false."
  }
}
