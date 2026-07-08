terraform {
  required_version = ">= 1.5.0"
}

locals {
  root_module_name = "root-module"

  root_working_directory = path.module
}

module "service_identity" {
  # This local path points from the root module to the child module.
  source = "./modules/service_identity"

  service_name = "checkout-api"

  environment = "dev"

  owner = "platform"
}

resource "terraform_data" "lesson" {
  input = {
    topic                  = "root module and child module"
    root_module_name       = local.root_module_name
    root_working_directory = local.root_working_directory
    child_module_role      = module.service_identity.module_role
    service_full_name      = module.service_identity.service_full_name
  }
}

output "root_module_name" {
  description = "The name used to identify the current working directory as the root module."
  value       = local.root_module_name
}

output "root_working_directory" {
  description = "The path of the root module working directory."
  value       = local.root_working_directory
}

output "child_module_role" {
  description = "A label returned by the child module."
  value       = module.service_identity.module_role
}

output "service_full_name" {
  description = "Service full name composed inside the child module."
  value       = module.service_identity.service_full_name
}

output "child_module_summary" {
  description = "Summary returned from the child module."
  value       = module.service_identity.summary
}
