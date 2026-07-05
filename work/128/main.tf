terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform teams mock file.
  # Hint: use jsondecode(file("${path.module}/data/hcp-teams.json")).
  mock = {}

  # TODO 2: Read the organization object from the decoded JSON object.
  # Hint: use local.mock.organization.
  organization = {}

  # TODO 3: Read the teams list from the decoded JSON object.
  # Hint: use local.mock.teams.
  teams = []

  # TODO 4: Read the invitations list from the decoded JSON object.
  # Hint: use local.mock.invitations.
  invitations = []

  # TODO 5: Return all team names in their original order.
  # Hint: use [for team in local.teams : team.name].
  team_names = []

  # TODO 6: Return only default team names.
  # Hint: use a for expression with if team.is_default.
  default_team_names = []

  # TODO 7: Find the owners team object.
  # Hint: use one([for team in local.teams : team if team.name == "owners"]).
  owners_team = {}

  # TODO 8: Check whether the owners team has highest access and can manage the organization.
  # Hint: check access_level == "highest" and contains(permissions, "manage_organization").
  owners_has_highest_access = false

  # TODO 9: Build a map of team member counts keyed by team name.
  # Hint: use { for team in local.teams : team.name => team.member_count }.
  team_member_counts = {}

  # TODO 10: Return only pending invitation emails.
  # Hint: use a for expression with if invitation.status == "pending".
  pending_invitation_emails = []

  # TODO 11: Build invitation target labels like "email -> team".
  # Hint: use [for invitation in local.invitations : "${invitation.email} -> ${invitation.team}"].
  invitation_targets = []

  # TODO 12: Build a map of invitations keyed by email.
  # Hint: use { for invitation in local.invitations : invitation.email => invitation }.
  invitations_by_email = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "hcp terraform teams and invitations"
    organization = try(local.organization.name, "")
    teams        = local.team_names
  }
}

output "organization_name" {
  description = "HCP Terraform organization name from mock data."
  value       = try(local.organization.name, "")
}

output "organization_plan" {
  description = "HCP Terraform plan from mock data."
  value       = try(local.organization.plan, "")
}

output "team_names" {
  description = "All HCP Terraform team names."
  value       = local.team_names
}

output "default_team_names" {
  description = "Default team names in the organization."
  value       = local.default_team_names
}

output "owners_team" {
  description = "The owners team object selected from teams."
  value       = local.owners_team
}

output "owners_has_highest_access" {
  description = "Whether owners has highest access and organization management permission."
  value       = local.owners_has_highest_access
}

output "team_member_counts" {
  description = "Team member counts keyed by team name."
  value       = local.team_member_counts
}

output "pending_invitation_emails" {
  description = "Emails with pending HCP Terraform invitations."
  value       = local.pending_invitation_emails
}

output "invitation_targets" {
  description = "Human-readable email to team invitation target labels."
  value       = local.invitation_targets
}

output "invitations_by_email" {
  description = "Invitations keyed by email address."
  value       = local.invitations_by_email
}
