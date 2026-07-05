terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform workspace mock file.
  # Hint: use jsondecode(file("${path.module}/data/workspaces.json")).
  mock = {}

  # TODO 2: Read the organization name from the decoded JSON object.
  # Hint: use local.mock.organization.
  organization_name = ""

  # TODO 3: Read the workspaces list from the decoded JSON object.
  # Hint: use local.mock.workspaces.
  workspaces = []

  # TODO 4: Select the names of workspaces that use Version Control Workflow.
  # Hint: use a for expression with if workspace.workflow == "vcs".
  vcs_workspace_names = []

  # TODO 5: Build a map of workspaces keyed by workspace name.
  # Hint: use { for workspace in local.workspaces : workspace.name => workspace }.
  workspaces_by_name = {}

  # TODO 6: Select the kplabs-terraform-learning workspace from the map.
  # Hint: use local.workspaces_by_name["kplabs-terraform-learning"].
  selected_workspace = {
    repository = ""
    variables  = []
    latest_run = {
      plan_status   = ""
      apply_status  = ""
      final_action  = ""
      discard_reason = ""
    }
  }

  # TODO 7: Collect all environment variable keys from the selected workspace.
  # Hint: filter selected_workspace.variables where variable.category == "env".
  aws_env_variable_keys = []

  # TODO 8: Collect sensitive environment variable keys from the selected workspace.
  # Hint: filter where variable.category == "env" && variable.sensitive.
  sensitive_env_variable_keys = []

  # TODO 9: Build run summary labels in the format "plan:<status>", "apply:<status>", "final:<action>".
  # Hint: read values from selected_workspace.latest_run.
  run_summary_labels = []
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "hcp terraform workspace vcs workflow"
    organization = local.organization_name
    workspaces   = local.workspaces
  }
}

output "organization_name" {
  description = "HCP Terraform organization name from the mock data."
  value       = local.organization_name
}

output "workspace_count" {
  description = "Number of workspaces in the mock organization."
  value       = length(local.workspaces)
}

output "vcs_workspace_names" {
  description = "Workspace names that use version control workflow."
  value       = local.vcs_workspace_names
}

output "workspace_repository" {
  description = "Repository linked to the selected HCP Terraform workspace."
  value       = local.selected_workspace.repository
}

output "aws_env_variable_keys" {
  description = "AWS provider environment variable keys configured in the selected workspace."
  value       = local.aws_env_variable_keys
}

output "sensitive_env_variable_keys" {
  description = "Sensitive environment variable keys configured in the selected workspace."
  value       = local.sensitive_env_variable_keys
}

output "run_summary_labels" {
  description = "Summary labels for the latest HCP Terraform run."
  value       = local.run_summary_labels
}
