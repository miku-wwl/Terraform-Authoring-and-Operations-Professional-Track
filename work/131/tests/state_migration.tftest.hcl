run "state_migration_model_is_correct" {
  command = plan

  assert {
    condition = output.command_names == [
      "create_local_state",
      "add_cloud_block",
      "terraform_login",
      "interactive_migration_init",
      "automation_migration_init"
    ]
    error_message = "command_names must preserve the expected state migration workflow order."
  }

  assert {
    condition = output.cloud_target == {
      organization             = "kplabs-demo"
      workspace                = "test-workspace"
      state_workspace_specific = true
    }
    error_message = "cloud_target must expose organization, workspace, and workspace-specific state behavior."
  }

  assert {
    condition = can(regex("organization\\s*=\\s*\\\"kplabs-demo\\\"", output.cloud_block_hcl)) && can(regex("name\\s*=\\s*\\\"test-workspace\\\"", output.cloud_block_hcl))
    error_message = "cloud_block_hcl must render a terraform cloud block containing the expected organization and workspace name."
  }

  assert {
    condition = output.migration_commands == {
      interactive = "terraform init -ignore-remote-version"
      automated   = "terraform init -migrate-state -input=false"
    }
    error_message = "migration_commands must include the interactive command and the non-interactive -migrate-state command."
  }

  assert {
    condition = output.version_strategy == {
      local_version             = "1.1.1"
      remote_workspace_version  = "1.4.1"
      version_mismatch          = true
      compatible_for_demo       = true
      can_ignore_remote_version = true
    }
    error_message = "version_strategy must detect the version mismatch and allow -ignore-remote-version only when compatibility is confirmed."
  }

  assert {
    condition = output.state_migration_contract == {
      before_location                            = "local"
      after_location                             = "HCP Terraform workspace"
      history_retained                           = true
      rollback_supported                         = true
      backup_required                            = true
      expected_local_state_file_after_migration  = "empty"
    }
    error_message = "state_migration_contract must describe the local-to-HCP state movement and required safety controls."
  }

  assert {
    condition = output.backup_files == [
      "terraform.tfstate.pre-migration.bak",
      "terraform.tfstate.backup"
    ]
    error_message = "backup_files must include an explicit pre-migration backup and Terraform's generated backup file."
  }

  assert {
    condition = output.migration_prompt == {
      appears_during = "terraform init"
      question       = "Should Terraform migrate your existing state?"
      answer         = "yes"
    }
    error_message = "migration_prompt must model the interactive terraform init migration confirmation."
  }
}
