run "hcp_variable_set_concepts_are_understood" {
  command = plan

  assert {
    condition = output.scope_choices == {
      share_across_projects      = "organization_owned"
      share_within_one_project   = "project_owned"
      all_org_current_and_future = "global"
      selected_workspaces_only   = "workspace_scoped"
      reusable_across_workspaces = true
    }
    error_message = "Review TODO 1: choose Variable Set ownership and scope according to the required reuse boundary."
  }

  assert {
    condition = output.variable_categories == {
      module_input_value       = "terraform"
      provider_process_setting = "environment"
      hcl_option_supported_by  = "terraform_only"
      sensitive_supported_by   = "both_categories"
      env_values_are_strings   = true
    }
    error_message = "Review TODO 2: Terraform and environment variables use different input channels and HCL behavior."
  }

  assert {
    condition = output.precedence_and_execution == {
      normal_same_key_winner       = "workspace_specific_variable"
      priority_set_can_override    = "more_specific_scopes_and_cli_values"
      overwritten_marker_location  = "workspace_variables_ui"
      local_execution_uses_varsets = false
      newest_edit_always_wins      = false
    }
    error_message = "Review TODO 3: distinguish normal precedence, priority sets, and Local execution mode."
  }

  assert {
    condition = output.security_judgements == {
      sensitive_is_write_only_in_ui_api  = true
      sensitive_guarantees_no_state_leak = false
      descriptions_are_encrypted         = false
      prefer_dynamic_credentials          = true
      credentials_should_be_global        = false
      trace_logs_need_protection           = true
    }
    error_message = "Review TODO 4: Sensitive protects UI/API visibility but does not replace least privilege or log/state protection."
  }
}
