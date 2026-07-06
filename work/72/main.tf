terraform {
  # Equivalent pessimistic constraint: ~> 1.5.
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    terraform = {
      source = "terraform.io/builtin/terraform"
    }
  }
}

locals {
  terraform_required_version = ">= 1.5.0, < 2.0.0"

  terraform_provider_source = "terraform.io/builtin/terraform"

  pinned_external_provider_example = "hashicorp/aws:5.54.1"

  settings_features = [
    "required_version",
    "required_providers",
    "backend",
    "experiments",
    "provider_meta"
  ]

  block_responsibilities = {
    provider_block  = "runtime provider configuration such as region and credentials"
    terraform_block = "project-level Terraform behavior such as versions, providers, backend and experiments"
  }

  settings_summary = {
    terraform_required_version       = local.terraform_required_version
    terraform_provider_source        = local.terraform_provider_source
    pinned_external_provider_example = local.pinned_external_provider_example
    settings_features                = local.settings_features
    block_responsibilities           = local.block_responsibilities
  }
}

resource "terraform_data" "settings_lesson" {
  input = {
    topic    = "terraform settings"
    settings = local.settings_summary
  }
}

output "terraform_required_version" {
  description = "Terraform CLI version constraint for this module."
  value       = local.terraform_required_version
}

output "terraform_provider_source" {
  description = "Source address of the built-in Terraform provider."
  value       = local.terraform_provider_source
}

output "pinned_external_provider_example" {
  description = "Example of an external provider pinned to a specific version."
  value       = local.pinned_external_provider_example
}

output "settings_features" {
  description = "Terraform settings features discussed in this lesson."
  value       = local.settings_features
}

output "block_responsibilities" {
  description = "Responsibility boundary between provider block and terraform block."
  value       = local.block_responsibilities
}

output "settings_summary" {
  description = "Combined settings summary used by the terraform_data resource."
  value       = local.settings_summary
}
