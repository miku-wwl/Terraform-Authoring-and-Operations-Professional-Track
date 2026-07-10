run "hcp_workspace_permission_concepts_are_understood" {
  command = plan

  assert {
    condition = output.role_choices == {
      view_workspace_information = "read"
      propose_without_apply      = "plan"
      daily_plan_and_apply       = "write"
      manage_settings_and_access = "admin"
      task_specific_permissions  = "custom"
    }
    error_message = "Review TODO 1: select Read, Plan, Write, Admin, or Custom according to the responsibility."
  }

  assert {
    condition = output.role_capabilities == {
      read_can_plan              = false
      plan_can_plan              = true
      plan_can_apply             = false
      write_can_apply            = true
      write_can_manage_settings  = false
      admin_can_delete_workspace = true
    }
    error_message = "Review TODO 2: Plan cannot apply, Write cannot manage settings, and Admin includes workspace deletion."
  }

  assert {
    condition = output.state_judgements == {
      outputs_only_reads        = "public_root_outputs"
      full_state_permission     = "read"
      create_state_versions     = "read_and_write"
      state_may_contain_secrets = true
      plan_preset_reads_state   = true
      state_cli_maintenance     = "read_and_write"
    }
    error_message = "Review TODO 3: distinguish public outputs, full state read, and state version write access."
  }

  assert {
    condition = output.security_scenarios == {
      auditor_runs_no_full_state  = "custom_role"
      sensitive_variable_read     = "value_remains_write_only"
      download_sentinel_mocks     = "treat_as_sensitive_access"
      attach_workspace_run_task   = "manage_workspace_run_tasks"
      custom_can_delete_workspace = false
      reduce_excess_access        = "review_all_additive_grants"
    }
    error_message = "Review TODO 4: use Custom for task-focused access and protect state, mocks, variables, and Run Task management."
  }
}
