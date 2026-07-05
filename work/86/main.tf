terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the module catalog JSON file.
  # Hint: use jsondecode(file("${path.module}/data/module-catalog.json")).
  catalog = {}

  # TODO 2: Read the modules list from the decoded catalog.
  # Hint: use local.catalog.modules.
  modules = []

  # TODO 3: Read the provided_inputs map from the decoded catalog.
  # Hint: use local.catalog.provided_inputs.
  provided_inputs = {}

  # TODO 4: Select module names that can create a resource plan without extra required inputs.
  # Hint: filter on module.creates_resources_without_required_inputs.
  direct_apply_module_names = []

  # TODO 5: Build a map of modules that require caller-provided inputs.
  # Hint: { for module in local.modules : module.name => module.required_inputs if length(module.required_inputs) > 0 }.
  modules_requiring_inputs = {}

  # TODO 6: For each module, calculate which required inputs are still missing.
  # Hint: compare module.required_inputs with keys(try(local.provided_inputs[module.name], {})).
  missing_inputs_by_module = {}

  # TODO 7a: Select source strings for modules whose module_path is not root.
  # Hint: this should capture sources that use //modules/....
  submodule_sources = []

  # TODO 7b: Select root modules that expose submodule folders.
  # Hint: filter where length(module.submodules) > 0.
  container_module_names = []

  # TODO 7c: Build a simple plan summary map keyed by module name.
  # Hint: { for module in local.modules : module.name => module.expected_plan_adds }.
  plan_adds_by_module = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic   = "terraform module input and structure awareness"
    modules = local.modules
  }
}

output "modules" {
  description = "Module metadata decoded from data/module-catalog.json."
  value       = local.modules
}

output "direct_apply_module_names" {
  description = "Modules that can produce a resource plan without extra required inputs in this mock catalog."
  value       = local.direct_apply_module_names
}

output "modules_requiring_inputs" {
  description = "Modules that require caller-provided input values."
  value       = local.modules_requiring_inputs
}

output "missing_inputs_by_module" {
  description = "Required inputs that are not present in provided_inputs."
  value       = local.missing_inputs_by_module
}

output "submodule_sources" {
  description = "Module source strings that reference a feature-specific submodule path."
  value       = local.submodule_sources
}

output "container_module_names" {
  description = "Root modules that expose feature-specific submodule folders."
  value       = local.container_module_names
}

output "plan_adds_by_module" {
  description = "Mock expected plan add count keyed by module name."
  value       = local.plan_adds_by_module
}
