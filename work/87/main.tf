terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the module candidate JSON mock file.
  # Hint: use jsondecode(file("${path.module}/data/module_candidates.json")).
  registry_data = {}

  # TODO 2: Read the modules list from the decoded JSON object.
  # Hint: use local.registry_data.modules.
  modules = []

  # TODO 3: Select names of modules whose service is ec2.
  # Hint: use a for expression with if module.service == "ec2".
  ec2_module_names = []

  # TODO 4: Build a map of trusted modules keyed by module name.
  # Trusted rule: downloads >= 100000, contributors >= 5, open_issues <= 10,
  # has_documentation, version_count >= 3, and not source_review_required.
  trusted_modules_by_name = {}

  # TODO 5: Select module names that require source review or should be avoided.
  # Review rule: source_review_required, contributors <= 1, missing docs,
  # version_count <= 1, or downloads < 10000.
  review_required_module_names = []

  # TODO 6: Build labels like "terraform-aws-modules/ec2-instance/aws:trusted".
  # Hint: use nested conditional expressions to choose trusted/review/usable.
  module_quality_labels = []

  # TODO 7: Recommend the first trusted EC2 module name.
  # Hint: filter trusted module keys or modules, then use try(list[0], "").
  recommended_ec2_module_name = ""
}

resource "terraform_data" "lesson" {
  input = {
    topic              = "choosing the right terraform module"
    module_count       = length(local.modules)
    recommended_module = local.recommended_ec2_module_name
  }
}

output "modules" {
  description = "Module candidates decoded from data/module_candidates.json."
  value       = local.modules
}

output "ec2_module_names" {
  description = "Names of module candidates for EC2."
  value       = local.ec2_module_names
}

output "trusted_modules_by_name" {
  description = "Trusted module candidates keyed by module name."
  value       = local.trusted_modules_by_name
}

output "trusted_module_names" {
  description = "Trusted module names."
  value       = keys(local.trusted_modules_by_name)
}

output "review_required_module_names" {
  description = "Module names that should be avoided or manually source-reviewed."
  value       = local.review_required_module_names
}

output "module_quality_labels" {
  description = "Module quality labels derived from maintenance and trust signals."
  value       = local.module_quality_labels
}

output "recommended_ec2_module_name" {
  description = "Recommended trusted EC2 module name."
  value       = local.recommended_ec2_module_name
}
