run "hcp_state_migration_concepts_are_understood" {
  command = plan

  assert {
    condition = output.pre_migration_checks == {
      stop_state_writers        = true
      independent_backup        = true
      commit_backup_to_git      = false
      prefer_same_cli_version   = true
      existing_target_has_state = false
    }
    error_message = "Review TODO 1: freeze writers, protect a backup, preserve CLI compatibility, and use an empty target."
  }

  assert {
    condition = output.migration_workflow == {
      cloud_block         = "select_hcp_organization_and_workspace"
      terraform_login     = "authenticate_local_cli_to_hcp"
      terraform_init      = "initialize_cloud_and_offer_state_copy"
      safe_sequence       = "freeze_backup_cloud_login_init_verify"
      recreates_resources = false
    }
    error_message = "Review TODO 2: cloud selects the target, login authenticates, and init migrates state without recreating resources."
  }

  assert {
    condition = output.init_flag_judgements == {
      plain_init         = "interactive_migration_prompt"
      migrate_state      = "attempt_copy_may_still_prompt"
      force_copy         = "auto_yes_and_implies_migrate_state"
      reconfigure        = "discard_backend_history_without_migration"
      force_copy_default = false
    }
    error_message = "Review TODO 3: -migrate-state can still prompt, -force-copy confirms automatically, and -reconfigure skips migration."
  }

  assert {
    condition = output.post_migration_judgements == {
      verify_remote_state_first       = true
      plan_checks_for_recreation      = true
      variables_auto_migrated         = false
      credentials_auto_migrated       = false
      delete_local_before_verify      = false
      ignore_version_is_last_resort   = true
      state_history_replaces_backup   = false
    }
    error_message = "Review TODO 4: verify state and plan, configure variables separately, and treat version bypass as a last resort."
  }
}
