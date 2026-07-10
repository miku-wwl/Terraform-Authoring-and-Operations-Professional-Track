run "vcs_workspace_workflow_is_understood" {
  command = plan

  assert {
    condition = output.vcs_workspace_settings == {
      repository        = "acme/infrastructure"
      branch            = "main"
      working_directory = "environments/prod/network"
      trigger_patterns  = ["/environments/prod/network/**/*.tf", "/modules/networking/**/*"]
      speculative_plans = true
      apply_method      = "manual"
    }
    error_message = "Review TODO 1: configure repository, branch, working directory, path triggers, PR plans, and manual apply."
  }

  assert {
    condition = output.event_results == {
      pull_request_opened = "speculative_plan_no_apply"
      push_to_main        = "standard_plan_wait_for_confirmation"
      confirm_apply       = "apply_infrastructure_changes"
      discard_run         = "no_apply_no_infrastructure_change"
    }
    error_message = "Review TODO 2: distinguish speculative PR plans, standard branch runs, confirm, and discard."
  }

  assert {
    condition = output.monorepo_design == {
      workspace_count        = 2
      network_working_dir    = "network"
      app_working_dir        = "app"
      independent_state      = true
      path_filtered_triggers = true
    }
    error_message = "Review TODO 3: use separate workspaces, working directories, state, and path-filtered triggers."
  }

  assert {
    condition = output.credential_strategy == {
      preferred_method             = "oidc_dynamic_credentials"
      credential_lifetime          = "per_run_short_lived"
      permission_model             = "least_privilege_role"
      store_admin_access_keys      = false
      sensitive_flag_is_sufficient = false
    }
    error_message = "Review TODO 4: prefer short-lived OIDC credentials and least privilege over stored administrator keys."
  }
}
