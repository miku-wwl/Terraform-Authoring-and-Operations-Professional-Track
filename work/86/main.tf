terraform {
  required_version = ">= 1.5.0"
}

locals {
  catalog = jsondecode(file("${path.module}/data/module-catalog.json"))

  modules = local.catalog.modules

  provided_inputs = local.catalog.provided_inputs

  direct_apply_module_names = [for module in local.modules : module.name if module.creates_resources_without_required_inputs]

  modules_requiring_inputs = { for module in local.modules : module.name => module.required_inputs if length(module.required_inputs) > 0 }

  missing_inputs_by_module = {
    for module in local.modules : module.name => [
      for input in module.required_inputs : input
      if !contains(keys(try(local.provided_inputs[module.name], {})), input)
    ]
    if length([
      for input in module.required_inputs : input
      if !contains(keys(try(local.provided_inputs[module.name], {})), input)
    ]) > 0
  }

  submodule_sources = [
    for module in local.modules : module.source
    if module.module_path != "root"
  ]

  container_module_names = [
    for module in local.modules : module.name
    if length(module.submodules) > 0
  ]

  plan_adds_by_module = {
    for module in local.modules : module.name => module.expected_plan_adds
  }
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
