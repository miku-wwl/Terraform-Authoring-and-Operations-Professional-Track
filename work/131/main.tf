terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the state migration mock file.
  # Hint: use jsondecode(file("${path.module}/data/state_migration.json")).
  mock = {}

  # TODO 2: Read the migration object from the decoded JSON object.
  # Hint: use local.mock.migration.
  migration = {}

  # TODO 3: Read the commands list from the migration object.
  # Hint: use local.migration.commands.
  commands = []

  # TODO 4: Build an ordered list of command names.
  # Hint: use [for command in local.commands : command.name].
  command_names = []

  # TODO 5: Build the cloud target map.
  # It must contain organization, workspace, and state_workspace_specific.
  cloud_target = {}

  # TODO 6: Render the terraform cloud block as a string.
  # Hint: use format() with local.cloud_target.organization and local.cloud_target.workspace.
  # Keep this as a string; do not add a real terraform cloud block in this lab.
  cloud_block_hcl = ""

  # TODO 7: Build migration commands for interactive and automated scenarios.
  # Interactive should use the command named interactive_migration_init.
  # Automated should use the command named automation_migration_init.
  # Hint: build a map keyed by command.name first, then select .cli.
  migration_commands = {}

  # TODO 8: Build a version strategy object.
  # Include local_version, remote_workspace_version, version_mismatch,
  # compatible_for_demo, and can_ignore_remote_version.
  # can_ignore_remote_version should be true only when versions differ and compatible_for_demo is true.
  version_strategy = {}

  # TODO 9: Build a state migration contract object.
  # Include before_location, after_location, history_retained, rollback_supported,
  # backup_required, and expected_local_state_file_after_migration.
  state_migration_contract = {}

  # TODO 10: Build the migration prompt object from local.migration.migration_prompt.
  # Include appears_during, question, and answer.
  migration_prompt = {}

  # TODO 11: Read the backup file list from local.migration.state.backup_files.
  backup_files = []
}

resource "terraform_data" "lesson" {
  input = {
    topic     = "migrate local state to hcp terraform"
    workspace = try(local.cloud_target.workspace, null)
  }
}

output "command_names" {
  description = "Ordered command names for local state to HCP Terraform migration."
  value       = local.command_names
}

output "cloud_target" {
  description = "HCP Terraform organization and workspace used as the remote state target."
  value       = local.cloud_target
}

output "cloud_block_hcl" {
  description = "Rendered HCL snippet for terraform cloud integration."
  value       = local.cloud_block_hcl
}

output "migration_commands" {
  description = "Interactive and automated init commands for state migration."
  value       = local.migration_commands
}

output "version_strategy" {
  description = "How to handle local and remote Terraform version mismatch during migration."
  value       = local.version_strategy
}

output "state_migration_contract" {
  description = "Safety and storage contract for migrating local state to HCP Terraform."
  value       = local.state_migration_contract
}

output "backup_files" {
  description = "State backup files that should exist before or during migration."
  value       = local.backup_files
}

output "migration_prompt" {
  description = "Interactive prompt shown by terraform init during state migration."
  value       = local.migration_prompt
}
