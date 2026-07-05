terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform mock file.
  # Hint: use jsondecode(file("${path.module}/data/hcp_platform.json")).
  hcp = {}

  # TODO 2: Read the organizations list from the decoded JSON object.
  # Hint: use local.hcp.organizations.
  organizations = []

  # TODO 3: Build a map of organization name to billing plan.
  # Hint: use { for org in local.organizations : org.name => org.billing_plan }.
  billing_plan_by_org = {}

  # TODO 4: Flatten projects across all organizations.
  # Each item should include org_name, project_name, team_access_enabled, workspace_count.
  # Hint: use flatten with nested for expressions over organizations and org.projects.
  project_inventory = []

  # TODO 5: Flatten workspaces across all organizations and projects.
  # Each item should include org_name, project_name, workspace_name, vcs_provider, repository, state_location.
  # Hint: use flatten with three nested for expressions.
  workspace_inventory = []

  # TODO 6: Select names of workspaces connected to VCS.
  # Hint: use if ws.vcs_provider != "none".
  vcs_connected_workspace_names = []

  # TODO 7: Build a map of VCS-connected workspace name to repository.
  # Hint: use { for ws in local.workspace_inventory : ws.workspace_name => ws.repository if ws.vcs_provider != "none" }.
  workspace_repository_map = {}

  # TODO 8: Build a map of workspace name to sensitive variable names.
  # Hint: use { for ws in local.workspace_inventory : ws.workspace_name => ws.sensitive_variables }.
  sensitive_variables_by_workspace = {}

  # Optional revision helper: identify organizations on the standard plan.
  # Hint: [for org in local.organizations : org.name if org.billing_plan == "standard"].
  standard_org_names = []
}

resource "terraform_data" "lesson" {
  input = {
    topic              = "hcp terraform organization project workspace structure"
    organization_count = length(local.organizations)
    workspace_count    = length(local.workspace_inventory)
  }
}

output "organizations" {
  description = "Organizations decoded from data/hcp_platform.json."
  value       = local.organizations
}

output "organization_count" {
  description = "Number of HCP Terraform organizations in the mock model."
  value       = length(local.organizations)
}

output "billing_plan_by_org" {
  description = "Billing plan keyed by organization name."
  value       = local.billing_plan_by_org
}

output "project_inventory" {
  description = "Flattened project inventory grouped by organization."
  value       = local.project_inventory
}

output "workspace_inventory" {
  description = "Flattened workspace inventory across organizations and projects."
  value       = local.workspace_inventory
}

output "workspace_count" {
  description = "Number of workspaces in the mock HCP Terraform model."
  value       = length(local.workspace_inventory)
}

output "vcs_connected_workspace_names" {
  description = "Workspace names that are connected to a VCS repository."
  value       = local.vcs_connected_workspace_names
}

output "workspace_repository_map" {
  description = "Repository path keyed by VCS-connected workspace name."
  value       = local.workspace_repository_map
}

output "sensitive_variables_by_workspace" {
  description = "Sensitive variable names keyed by workspace name."
  value       = local.sensitive_variables_by_workspace
}

output "standard_org_names" {
  description = "Organizations using the standard plan in the mock model."
  value       = local.standard_org_names
}
