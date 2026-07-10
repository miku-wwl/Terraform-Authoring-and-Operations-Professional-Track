terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode data/hcp_workspace.json.
  # Hint: use jsondecode(file("${path.module}/data/hcp_workspace.json")).
  hcp = {}

  # TODO 2: Read the workspace object from the decoded data.
  workspace = {}

  # TODO 3: Build a summary with organization, project, workspace,
  # terraform_version, and execution_mode.
  workspace_summary = {}

  # TODO 4: Build a VCS source label in this format:
  # provider:repository@branch
  vcs_source = ""

  # TODO 5: Extract the ordered phase names from local.hcp.run.phases.
  run_phase_names = []

  # TODO 6: Select policy names whose status is "failed".
  failed_policy_names = []

  # TODO 7: Select keys for variables where sensitive is true.
  sensitive_variable_keys = []

  # TODO 8: Classify variable keys by category.
  terraform_variable_keys = []
  environment_variable_keys = []

  # TODO 9: A run is blocked when at least one policy failed.
  # Manual approval is required when auto_apply is false.
  run_blocked              = false
  manual_approval_required = false
}

resource "terraform_data" "lesson" {
  input = {
    topic     = "HCP Terraform workspace and run workflow"
    workspace = local.workspace_summary
    run = {
      phases                   = local.run_phase_names
      failed_policies          = local.failed_policy_names
      blocked                  = local.run_blocked
      manual_approval_required = local.manual_approval_required
    }
  }
}

output "workspace_summary" {
  description = "Summary of the mock HCP Terraform workspace."
  value       = local.workspace_summary
}

output "vcs_source" {
  description = "VCS provider, repository, and branch used by the workspace."
  value       = local.vcs_source
}

output "run_phase_names" {
  description = "Ordered phases in the mock HCP Terraform run."
  value       = local.run_phase_names
}

output "failed_policy_names" {
  description = "Policies that failed during the policy check phase."
  value       = local.failed_policy_names
}

output "sensitive_variable_keys" {
  description = "Workspace variable keys marked sensitive."
  value       = local.sensitive_variable_keys
}

output "terraform_variable_keys" {
  description = "Workspace variables in the Terraform category."
  value       = local.terraform_variable_keys
}

output "environment_variable_keys" {
  description = "Workspace variables in the environment category."
  value       = local.environment_variable_keys
}

output "run_blocked" {
  description = "Whether a failed policy prevents the run from applying."
  value       = local.run_blocked
}

output "manual_approval_required" {
  description = "Whether a person must confirm the apply."
  value       = local.manual_approval_required
}
