terraform {
  # TODO 1: Restrict the Terraform CLI version for this module.
  # Hint: allow Terraform 1.5+ but block Terraform 2.x.
  required_version = ">= 1.0.0"

  required_providers {
    # TODO 2: Declare the built-in Terraform provider used by terraform_data.
    # Hint: use the built-in provider source address.
    terraform = {
      source = "terraform.io/builtin/terraform"
    }
  }
}

locals {
  # TODO 3: Record the same Terraform CLI version constraint used above.
  terraform_required_version = ""

  # TODO 4: Record the built-in Terraform provider source address.
  terraform_provider_source = ""

  # TODO 5: Record an external provider pinned-version example from the lesson.
  # Hint: use the format provider/source:version.
  pinned_external_provider_example = ""

  # TODO 6: List the Terraform settings features discussed in the lesson.
  settings_features = []

  # TODO 7: Explain which block owns which responsibility.
  block_responsibilities = {
    provider_block  = ""
    terraform_block = ""
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
