run "hcp_terraform_overview_is_understood" {
  command = plan

  assert {
    condition = output.platform_facts == {
      replaces_terraform_language        = false
      terraform_cli_still_useful         = true
      hcp_workspace_equals_cli_workspace = false
      vcs_connection_is_required         = false
    }
    error_message = "Review TODO 1: HCP Terraform complements Terraform CLI, its workspaces differ from CLI workspaces, and VCS is optional."
  }

  assert {
    condition = output.governed_run_phases == [
      "vcs_change",
      "plan",
      "cost_estimation",
      "policy_check",
      "manual_approval",
      "apply"
    ]
    error_message = "Review TODO 2: preserve the example governed run order from VCS change through apply."
  }

  assert {
    condition = output.scenario_answers == {
      preserve_plan_apply_history = "run_history"
      share_and_version_state     = "remote_state"
      block_untagged_resources    = "policy_enforcement"
      share_internal_modules      = "private_registry"
      protect_variable_values     = "sensitive_variables"
      trigger_runs_from_commits   = "vcs_integration"
    }
    error_message = "Review TODO 3: map each team problem to the matching HCP Terraform capability."
  }

  assert {
    condition = output.run_decisions == {
      mandatory_policy_failed         = true
      failed_policy_blocks_apply      = true
      auto_apply                      = false
      manual_confirmation_if_eligible = true
    }
    error_message = "Review TODO 4: a mandatory policy failure blocks apply, while auto_apply=false requires confirmation for an eligible run."
  }
}
