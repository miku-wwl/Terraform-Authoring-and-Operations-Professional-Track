terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform mock workspace data.
  # Hint: use jsondecode(file("${path.module}/data/hcp_workspaces.json")).
  hcp = {}

  # TODO 2: Convert the workspace list into a map keyed by workspace name.
  # Hint: use { for workspace in local.hcp.workspaces : workspace.name => workspace }.
  workspaces_by_name = {}

  # TODO 3: Select the source and dependent workspaces from the map.
  # Hint: use local.workspaces_by_name["network-project"] and ["security-project"].
  network_workspace  = {}
  security_workspace = {}

  # TODO 4: Read the public IP output published by the network workspace.
  # Hint: use local.network_workspace.outputs.public_ips.
  network_public_ips = []

  # TODO 5: Check whether network-project shares state with security-project.
  # Hint: use contains(local.network_workspace.remote_state_sharing.shared_with, "security-project").
  network_shares_state_with_security = false

  # TODO 6: Check whether security-project has a run trigger from network-project.
  # Hint: use contains(local.security_workspace.run_triggers.source_workspaces, "network-project").
  security_has_run_trigger_from_network = false

  # TODO 7: Build a summary object for the run-trigger dependency.
  # Hint: include source, target, auto_apply, output_name, and datasource.
  run_trigger_summary = {}

  # TODO 8: Build firewall allowlist labels from network_public_ips.
  # Hint: use [for ip in local.network_public_ips : "allow:${ip}"].
  firewall_allowlist_rules = []
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "hcp terraform run triggers"
    organization = try(local.hcp.organization, "")
    dependency   = local.run_trigger_summary
  }
}

output "organization" {
  description = "HCP Terraform organization name from the mock data."
  value       = try(local.hcp.organization, "")
}

output "workspaces_by_name" {
  description = "Workspace objects keyed by workspace name."
  value       = local.workspaces_by_name
}

output "network_public_ips" {
  description = "Public IP outputs published by the network workspace."
  value       = local.network_public_ips
}

output "network_shares_state_with_security" {
  description = "Whether the network workspace shares remote state outputs with the security workspace."
  value       = local.network_shares_state_with_security
}

output "security_has_run_trigger_from_network" {
  description = "Whether the security workspace is triggered by the network workspace."
  value       = local.security_has_run_trigger_from_network
}

output "run_trigger_summary" {
  description = "Summary of the HCP Terraform run trigger dependency."
  value       = local.run_trigger_summary
}

output "firewall_allowlist_rules" {
  description = "Firewall allowlist rule labels derived from the network workspace outputs."
  value       = local.firewall_allowlist_rules
}
