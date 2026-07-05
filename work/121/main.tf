terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform mock file.
  # Hint: use jsondecode(file("${path.module}/data/hcp-structure.json")).
  hcp = {}

  # TODO 2: Read the organization object from the decoded JSON object.
  # Hint: use local.hcp.organization.
  organization = {}

  # TODO 3: Read the projects list from the decoded JSON object.
  # Hint: use local.hcp.projects.
  projects = []

  # TODO 4: Read the workspaces list from the decoded JSON object.
  # Hint: use local.hcp.workspaces.
  workspaces = []

  # TODO 5: Read the registry features list from the decoded JSON object.
  # Hint: use local.hcp.registry_features.
  registry_features = []

  # TODO 6: Extract the organization name.
  # Hint: use local.organization.name.
  organization_name = ""

  # TODO 7: Select project names that were created by the user.
  # Hint: use a for expression with if project.auto_created == false.
  user_created_project_names = []

  # TODO 8A: Build a map of workspace name => workflow.
  # Hint: use { for workspace in local.workspaces : workspace.name => workspace.workflow }.
  workspace_workflows_by_name = {}

  # TODO 8B: Build workspace/project labels like "learning-vcs-workspace->Terraform Learning".
  # Hint: use [for workspace in local.workspaces : "${workspace.name}->${workspace.project}"].
  workspace_project_pairs = []

  # TODO 8C: Select enabled private registry feature names.
  # Hint: use [for feature in local.registry_features : feature.name if feature.enabled].
  registry_feature_names = []

  # TODO 8D: Build a free plan summary like "free:500 resources".
  # Hint: use "${local.organization.plan}:${local.organization.resource_limit} resources".
  free_plan_summary = ""
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "hcp terraform organization project workspace basics"
    organization = local.organization_name
    projects     = local.user_created_project_names
    workspaces   = local.workspace_workflows_by_name
  }
}

output "organization_name" {
  description = "HCP Terraform organization name decoded from JSON."
  value       = local.organization_name
}

output "projects" {
  description = "Projects decoded from data/hcp-structure.json."
  value       = local.projects
}

output "user_created_project_names" {
  description = "Project names where auto_created is false."
  value       = local.user_created_project_names
}

output "workspaces" {
  description = "Workspaces decoded from data/hcp-structure.json."
  value       = local.workspaces
}

output "workspace_workflows_by_name" {
  description = "Workspace workflow keyed by workspace name."
  value       = local.workspace_workflows_by_name
}

output "workspace_project_pairs" {
  description = "Workspace to project relationship labels."
  value       = local.workspace_project_pairs
}

output "registry_feature_names" {
  description = "Enabled private registry feature names."
  value       = local.registry_feature_names
}

output "free_plan_summary" {
  description = "Summary of HCP Terraform free plan resource limit."
  value       = local.free_plan_summary
}
