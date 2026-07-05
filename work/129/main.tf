terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform permission mock file.
  # Hint: use jsondecode(file("${path.module}/data/permissions.json")).
  mock = {}

  # TODO 2: Read the organization name from the decoded JSON object.
  # Hint: use local.mock.organization.
  organization_name = ""

  # TODO 3: Read the teams list from the decoded JSON object.
  # Hint: use local.mock.teams.
  teams = []

  # TODO 4: Build a map of teams keyed by team name.
  # Hint: use { for team in local.teams : team.name => team }.
  teams_by_name = {}

  # TODO 5: Find teams that have full organization access.
  # Hint: use a for expression with if team.full_organization_access.
  owner_team_names = []

  # TODO 6: Select safe team names for normal user invitations, excluding owners.
  # Hint: filter where team.full_organization_access == false.
  safe_invite_team_names = []

  # TODO 7: Read workspaces and build a map keyed by workspace name.
  # Hint: read local.mock.workspaces, then use a for expression keyed by workspace.name.
  workspaces         = []
  workspaces_by_name = {}

  # TODO 8: Select the dev-web-app workspace from the map.
  # Hint: use local.workspaces_by_name["dev-web-app"].
  selected_workspace = {
    name        = ""
    project     = ""
    team_access = []
  }

  # TODO 9: Build a workspace access map keyed by team name.
  # Hint: use { for access in local.selected_workspace.team_access : access.team => access }.
  workspace_access_by_team = {}

  # TODO 10: Select developers access, build permission labels, and map invitations.
  # Hints:
  # - local.workspace_access_by_team["developers"]
  # - concat([for p in ...], ["variables:${...}", "state:${...}"])
  # - { for invite in local.mock.pending_invitations : invite.email => invite.team }
  developer_access = {
    access_level    = ""
    run_permissions = []
    variable_access = ""
    state_access    = ""
    sentinel_mocks  = ""
    run_tasks       = ""
  }

  developer_permission_labels = []
  invite_team_assignments     = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "hcp terraform team and workspace permissions"
    organization = local.organization_name
    teams        = local.teams
    workspace    = local.selected_workspace.name
  }
}

output "organization_name" {
  description = "HCP Terraform organization name from the permission mock data."
  value       = local.organization_name
}

output "team_count" {
  description = "Number of teams in the mock organization."
  value       = length(local.teams)
}

output "owner_team_names" {
  description = "Teams with full organization access."
  value       = local.owner_team_names
}

output "safe_invite_team_names" {
  description = "Teams suitable for normal user invitations, excluding owners."
  value       = local.safe_invite_team_names
}

output "selected_workspace_name" {
  description = "Workspace selected for workspace-level permission analysis."
  value       = local.selected_workspace.name
}

output "developer_workspace_access_level" {
  description = "Workspace access level assigned to the developers team."
  value       = local.developer_access.access_level
}

output "developer_permission_labels" {
  description = "Normalized permission labels for developers on the selected workspace."
  value       = local.developer_permission_labels
}

output "security_workspace_state_access" {
  description = "State access assigned to the security team on the selected workspace."
  value       = try(local.workspace_access_by_team["security"].state_access, "")
}

output "owner_private_registry_permission" {
  description = "Private registry permission assigned to the owners team."
  value       = try(local.teams_by_name["owners"].private_registry_permission, "")
}

output "invite_team_assignments" {
  description = "Pending invitations mapped from email address to team name."
  value       = local.invite_team_assignments
}
