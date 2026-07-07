terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the module structure mock file.
  # Hint: use jsondecode(file("${path.module}/data/module-structure.json")).
  structure = {}

  # TODO 2: Read the root folder list from the decoded JSON object.
  # Hint: use local.structure.root_folders.
  root_folders = []

  # TODO 3: Read the module records from the decoded JSON object.
  # Hint: use local.structure.modules.
  modules = []

  # TODO 4: Read the team records from the decoded JSON object.
  # Hint: use local.structure.teams.
  teams = []

  # TODO 5: Read the planned team-to-module references from the decoded JSON object.
  # Hint: use local.structure.references.
  references = []

  # TODO 6: Build a list of reusable module paths.
  # Hint: use [for module in local.modules : module.path].
  module_paths = []

  # TODO 7: Build a list of team workspace paths.
  # Hint: use [for team in local.teams : team.path].
  team_paths = []

  # TODO 8: Build module and team name lists.
  # Hint: use for expressions over local.modules and local.teams.
  module_names = []
  team_names   = []

  # TODO 9: Build a map of team name to planned internal module source path.
  # Hint: use { for ref in local.references : ref.team => ref.source }.
  team_source_by_team = {}

  # TODO 10: Build a complete list of base structure paths.
  # Hint: use concat(local.root_folders, local.module_paths, local.team_paths).
  base_structure_paths = []

  # TODO 11: Build a map of team name to planned module names.
  # Hint: use { for team in local.teams : team.name => team.planned_modules }.
  planned_modules_by_team = {}

  # TODO 12: Read the internal module policy object.
  # Hint: use local.structure.organization_policy.
  internal_module_policy = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic                = "internal terraform module base structure"
    root_folders         = local.root_folders
    module_paths         = local.module_paths
    team_paths           = local.team_paths
    team_source_by_team  = local.team_source_by_team
    base_structure_paths = local.base_structure_paths
  }
}

output "root_folders" {
  description = "Top-level folders in the internal module repository."
  value       = local.root_folders
}

output "module_names" {
  description = "Reusable module names."
  value       = local.module_names
}

output "team_names" {
  description = "Team workspace names."
  value       = local.team_names
}

output "module_paths" {
  description = "Reusable module folder paths."
  value       = local.module_paths
}

output "team_paths" {
  description = "Team workspace folder paths."
  value       = local.team_paths
}

output "team_source_by_team" {
  description = "Planned relative module source path for each team."
  value       = local.team_source_by_team
}

output "planned_modules_by_team" {
  description = "Module names each team plans to reference."
  value       = local.planned_modules_by_team
}

output "internal_module_policy" {
  description = "Organization policy explaining why internal modules are preferred."
  value       = local.internal_module_policy
}

output "base_structure_paths" {
  description = "Complete base folder structure for the internal module repository."
  value       = local.base_structure_paths
}
