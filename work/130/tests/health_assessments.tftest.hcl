run "hcp_health_assessment_concepts_are_understood" {
  command = plan

  assert {
    condition = output.assessment_type_choices == {
      console_changed_security_group = "drift_detection"
      website_returns_500            = "continuous_validation"
      certificate_expired            = "continuous_validation"
      actual_differs_from_config      = "drift_detection"
      state_drift_only                = "not_health_drift_detection"
    }
    error_message = "Review TODO 1: distinguish configuration drift from failed post-provision health assertions and state drift."
  }

  assert {
    condition = output.assessment_behaviors == {
      runs_periodically           = true
      changes_infrastructure      = false
      updates_state_automatically = false
      interrupts_active_runs      = false
      alert_equals_remediation    = false
    }
    error_message = "Review TODO 2: assessments report health without modifying infrastructure, state, or active runs."
  }

  assert {
    condition = output.validation_judgements == {
      evaluates_check_blocks       = true
      evaluates_pre_postconditions = true
      check_recommended_post_apply = true
      failed_check_blocks_block_apply = false
      evaluates_after_provisioning = true
    }
    error_message = "Review TODO 3: Continuous Validation evaluates assertions, while a failed check block does not block apply."
  }

  assert {
    condition = output.readiness_and_response == {
      execution_modes          = "remote_or_agent"
      successful_apply_needed  = true
      failed_latest_run_pauses = true
      view_health_permission   = "workspace_read"
      on_demand_permission     = "workspace_admin"
      unwanted_drift_action    = "plan_and_apply_to_restore_configuration"
      accepted_drift_action    = "update_configuration_then_apply"
    }
    error_message = "Review TODO 4: check workspace readiness and choose the correct permission and drift response."
  }
}
