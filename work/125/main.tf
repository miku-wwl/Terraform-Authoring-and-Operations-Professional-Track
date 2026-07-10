terraform {
  required_version = ">= 1.6.0"
}

variable "workspace_name" {
  description = "Workspace whose effective variables should be calculated."
  type        = string
  default     = "checkout-api"
}

locals {
  # TODO 1: Read and decode data/mock.json.
  # Hint: jsondecode(file("${path.module}/data/mock.json"))
  mock = {
    workspaces          = []
    variable_sets       = []
    workspace_variables = {}
  }

  # TODO 2: Select the workspace whose name matches var.workspace_name.
  # Hint: use one([...]) with a for expression and an if clause.
  selected_workspace = {
    name    = ""
    project = ""
  }

  # TODO 3: Keep Variable Sets whose scope applies to the selected workspace.
  # A set applies when scope.type is global, its project matches, or its workspace matches.
  applicable_variable_sets = []

  # TODO 4: Flatten variables from every applicable Variable Set.
  # Add source = variable_set.name to each variable using merge().
  variable_set_entries = []

  # TODO 5: Build an object keyed by variable key from variable_set_entries.
  variable_set_map = {}

  # TODO 6: Read variables defined directly on the selected workspace.
  # Hint: use lookup(local.mock.workspace_variables, var.workspace_name, []).
  workspace_entries = []

  # TODO 7: Build an object keyed by variable key from workspace_entries.
  # Add source = "workspace" to every item.
  workspace_variable_map = {}

  # TODO 8: Merge inherited variables and workspace variables.
  # The second argument to merge() wins on duplicate keys.
  effective_variables = {}

  # TODO 9: Find and sort keys present in both maps.
  overridden_keys = []

  # TODO 10: Derive category and sensitivity views from effective_variables.
  terraform_variable_values = {}
  environment_variable_values = {}
  sensitive_keys = []
}

resource "terraform_data" "lesson" {
  input = {
    topic                = "HCP Terraform variable sets"
    workspace            = var.workspace_name
    effective_variables  = local.effective_variables
    overridden_variables = local.overridden_keys
  }
}

output "selected_workspace" {
  description = "Selected workspace metadata."
  value       = local.selected_workspace
}

output "applicable_variable_set_names" {
  description = "Variable Sets whose scope applies to the selected workspace."
  value       = [for variable_set in local.applicable_variable_sets : variable_set.name]
}

output "effective_variable_values" {
  description = "Final values after workspace variables override Variable Set values."
  value       = { for key, item in local.effective_variables : key => item.value }
}

output "effective_variable_sources" {
  description = "Source that supplied each effective variable."
  value       = { for key, item in local.effective_variables : key => item.source }
}

output "overridden_keys" {
  description = "Variable Set keys overridden by workspace variables."
  value       = local.overridden_keys
}

output "terraform_variable_values" {
  description = "Effective variables in the Terraform variable category."
  value       = local.terraform_variable_values
}

output "environment_variable_values" {
  description = "Effective variables in the environment variable category."
  value       = local.environment_variable_values
}

output "sensitive_keys" {
  description = "Effective variable keys marked sensitive."
  value       = local.sensitive_keys
}
