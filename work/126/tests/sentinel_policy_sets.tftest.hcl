run "sentinel_policy_as_code_concepts_are_understood" {
  command = plan

  assert {
    condition = output.policy_model == {
      sentinel          = "policy_as_code_framework"
      policy            = "single_governance_rule"
      policy_set        = "collection_and_scope_assignment"
      primary_input     = "terraform_run_data"
      runs_before_apply = true
    }
    error_message = "Review TODO 1: distinguish the Sentinel framework, one policy, and a scoped Policy Set."
  }

  assert {
    condition = output.enforcement_choices == {
      advisory       = "warn_and_continue"
      soft_mandatory = "pause_until_authorized_override_or_discard"
      hard_mandatory = "must_pass_and_cannot_be_overridden"
      configured_in  = "policy_deployment"
    }
    error_message = "Review TODO 2: advisory warns, soft-mandatory permits an authorized override, and hard-mandatory cannot be overridden."
  }

  assert {
    condition = output.policy_set_judgements == {
      can_apply_globally             = true
      can_target_projects_workspaces = true
      can_target_workspace_tags      = true
      one_framework_per_policy_set   = true
      vcs_recommended_for_audit      = true
      sentinel_always_requires_paid  = false
    }
    error_message = "Review TODO 3: Policy Sets support multiple scopes, one framework per set, and auditable VCS management."
  }

  assert {
    condition = output.governance_scenarios == {
      plan_failed_before_policy      = "policy_check_does_not_run"
      missing_required_resource_tags = "sentinel_pre_apply_policy"
      manual_cloud_console_resource  = "cloud_side_compliance_control"
      advisory_policy_failed         = "run_continues_with_warning"
      hard_mandatory_policy_failed   = "run_cannot_continue_to_apply"
    }
    error_message = "Review TODO 4: apply Sentinel to successful Terraform plans and use cloud-side controls for out-of-band resources."
  }
}
