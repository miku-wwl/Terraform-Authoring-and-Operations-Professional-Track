terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the exam pointer JSON file.
  # Hint: use jsondecode(file("${path.module}/data/exam_pointers.json")).
  exam_pointers = {}

  # TODO 2: Return the three HCP Terraform concept names: organization, project, workspace.
  # Hint: these are the keys under local.exam_pointers.hcp_terraform.
  hcp_concepts = []

  # TODO 3: Read what an organization acts as a shared space for.
  # Hint: local.exam_pointers.hcp_terraform.organization.shared_space_for.
  organization_capabilities = []

  # TODO 4: Read the key workspace features.
  # Hint: local.exam_pointers.hcp_terraform.workspace.features.
  workspace_features = []

  # TODO 5: Read the HCP Terraform project purpose string.
  # Hint: local.exam_pointers.hcp_terraform.project.purpose.
  project_purpose = ""

  # TODO 6: Read where a policy set can be enforced.
  # Hint: local.exam_pointers.sentinel.policy_set_targets.
  policy_set_targets = []

  # TODO 7: Read whether policy sets are directly attached at team level.
  # Hint: this should be false for this lab's MCQ pointer.
  policy_set_direct_team_attachment = true

  # TODO 8: Read variable set scopes.
  # Hint: global, project, workspace.
  variable_set_scopes = []

  # TODO 9: Read variable categories supported in variable sets.
  # Hint: Terraform variable and environment variable.
  variable_categories = []

  # TODO 10: Calculate the effective db_write_capacity after workspace override.
  # Hint: if the workspace override key is db_write_capacity, use its value instead of the variable set value.
  effective_db_write_capacity = 0

  # TODO 11: Mark where the effective db_write_capacity came from.
  # Hint: use "workspace_variable" when the override key matches; otherwise use "variable_set".
  effective_variable_source = ""

  # TODO 12: Read whether Vault provider secrets are plaintext in Terraform state.
  # Hint: local.exam_pointers.state_and_cli.vault_secrets_plaintext_in_state.
  vault_secrets_plaintext_in_state = false

  # TODO 13: Read saved plan workflow commands.
  # Hint: plan -out first, then apply the saved plan file.
  saved_plan_commands = []

  # TODO 14: Read the HCP Terraform workspace outputs data source name.
  # Hint: it is not terraform_remote_state in this HCP Terraform pointer.
  hcp_workspace_outputs_data_source = ""

  # TODO 15: Read the remaining run and troubleshooting pointers.
  # Hint: values are under local.exam_pointers.runs and local.exam_pointers.state_and_cli.
  run_trigger_behavior             = ""
  run_task_stages                  = []
  check_block_failure_behavior     = ""
  cli_flags_for_automation         = []
  vcs_trigger_troubleshooting_reason = ""
}

resource "terraform_data" "lesson" {
  input = {
    topic                              = "terraform professional mcq exam pointers"
    hcp_concepts                       = local.hcp_concepts
    effective_db_write_capacity        = local.effective_db_write_capacity
    hcp_workspace_outputs_data_source  = local.hcp_workspace_outputs_data_source
    check_block_failure_behavior       = local.check_block_failure_behavior
  }
}

output "hcp_concepts" {
  description = "Core HCP Terraform object names used in the MCQ pointers."
  value       = local.hcp_concepts
}

output "organization_capabilities" {
  description = "What an HCP Terraform organization provides a shared space for."
  value       = local.organization_capabilities
}

output "workspace_features" {
  description = "Key workspace-level features."
  value       = local.workspace_features
}

output "project_purpose" {
  description = "Purpose of HCP Terraform projects."
  value       = local.project_purpose
}

output "policy_set_targets" {
  description = "Targets where policy sets can be enforced."
  value       = local.policy_set_targets
}

output "policy_set_direct_team_attachment" {
  description = "Whether policy sets are directly attached at team level."
  value       = local.policy_set_direct_team_attachment
}

output "variable_set_scopes" {
  description = "Scopes where variable sets can apply."
  value       = local.variable_set_scopes
}

output "variable_categories" {
  description = "Variable categories supported by HCP Terraform variable sets."
  value       = local.variable_categories
}

output "effective_db_write_capacity" {
  description = "Effective db_write_capacity after applying workspace variable override precedence."
  value       = local.effective_db_write_capacity
}

output "effective_variable_source" {
  description = "Source of the effective db_write_capacity value."
  value       = local.effective_variable_source
}

output "vault_secrets_plaintext_in_state" {
  description = "Whether Vault provider secrets remain plaintext in Terraform state."
  value       = local.vault_secrets_plaintext_in_state
}

output "saved_plan_commands" {
  description = "Commands for saving and applying a Terraform plan file."
  value       = local.saved_plan_commands
}

output "hcp_workspace_outputs_data_source" {
  description = "Data source used to retrieve HCP Terraform workspace outputs."
  value       = local.hcp_workspace_outputs_data_source
}

output "run_trigger_behavior" {
  description = "Run trigger behavior between source and destination workspaces."
  value       = local.run_trigger_behavior
}

output "run_task_stages" {
  description = "Run task stages."
  value       = local.run_task_stages
}

output "check_block_failure_behavior" {
  description = "Behavior when a check block fails."
  value       = local.check_block_failure_behavior
}

output "cli_flags_for_automation" {
  description = "Useful Terraform CLI flags for automation and readable logs."
  value       = local.cli_flags_for_automation
}

output "vcs_trigger_troubleshooting_reason" {
  description = "Common reason why VCS-triggered workspace runs do not start."
  value       = local.vcs_trigger_troubleshooting_reason
}
