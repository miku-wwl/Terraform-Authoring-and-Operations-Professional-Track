run "hcp_run_trigger_concepts_are_understood" {
  command = plan

  assert {
    condition = output.dependency_model == {
      data_channel        = "workspace_outputs"
      timing_channel      = "run_trigger"
      source_workspace    = "upstream_producer"
      target_workspace    = "downstream_consumer"
      reading_auto_queues = false
    }
    error_message = "Review TODO 1: outputs carry dependency data, while a Run Trigger queues the downstream workspace."
  }

  assert {
    condition = output.trigger_behaviors == {
      successful_apply_queues_run        = true
      speculative_plan_queues_run        = false
      failed_apply_queues_run            = false
      triggered_run_auto_applies_default = false
      dedicated_auto_apply_setting       = true
    }
    error_message = "Review TODO 2: only a successful source apply triggers the downstream run, and auto-apply is a separate setting."
  }

  assert {
    condition = output.access_judgements == {
      new_workspace_shares_state_default = false
      prefer_specific_consumers           = true
      trigger_grants_state_access          = false
      state_access_creates_trigger         = false
      create_trigger_needs_target_admin    = true
      create_trigger_needs_source_run_read = true
    }
    error_message = "Review TODO 3: state sharing, Run Triggers, and their permissions are independent controls."
  }

  assert {
    condition = output.dependency_scenarios == {
      downstream_reads_upstream_output = "outputs_access_plus_run_trigger"
      upstream_apply_failed             = "do_not_queue_downstream"
      manual_cloud_console_change       = "run_trigger_does_not_detect_it"
      all_configs_in_one_workspace      = "not_required_for_dependency"
      evidence_of_trigger_direction     = "inbound_on_target_outbound_on_source"
    }
    error_message = "Review TODO 4: combine output access with the correct trigger direction and respect its detection boundary."
  }
}
