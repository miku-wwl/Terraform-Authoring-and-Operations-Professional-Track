# Lab note:
# - A reusable module should have a small, predictable structure: README.md,
#   main.tf, variables.tf, and outputs.tf as the minimum useful contract.
# - versions.tf is commonly used to keep Terraform and provider constraints
#   separate from resource logic.
# - fileset() and setsubtract() can validate module structure, while
#   jsondecode(file(...)) plus for expressions can turn architecture data into
#   clear module boundaries instead of one large monolithic module.
terraform {
  required_version = ">= 1.5.0"
}

locals {
  architecture = jsondecode(file("${path.module}/data/module_architecture.json"))

  services = local.architecture.requested_architecture.services

  standard_required_files = toset(["README.md", "main.tf", "variables.tf", "outputs.tf"])

  ec2_module_files = toset(fileset("${path.module}/modules/ec2", "*"))

  missing_required_files = setsubtract(local.standard_required_files, local.ec2_module_files)

  module_boundaries = sort(tolist(toset([for service in local.services : service.module_boundary])))

  module_catalog = {
    for boundary in local.module_boundaries : boundary => [
      for service in local.services : service.name
      if service.module_boundary == boundary
    ]
  }
}

module "ec2" {
  source = "./modules/ec2"

  service_name  = "ec2"
  instance_type = "t3.micro"
  tags = {
    Environment = "training"
    ManagedBy   = "terraform"
  }
}

resource "terraform_data" "lesson" {
  input = {
    topic                 = "standard module structure"
    standard_required     = local.standard_required_files
    detected_module_files = local.ec2_module_files
    module_boundaries     = local.module_boundaries
  }
}

output "standard_required_files" {
  description = "Minimal recommended files for a reusable Terraform module."
  value       = local.standard_required_files
}

output "ec2_module_files" {
  description = "Files detected in modules/ec2."
  value       = local.ec2_module_files
}

output "missing_required_files" {
  description = "Required standard module files missing from modules/ec2."
  value       = local.missing_required_files
}

output "architecture_service_count" {
  description = "Number of services in the requested architecture mock."
  value       = length(local.services)
}

output "module_boundaries" {
  description = "Unique module responsibility boundaries inferred from the architecture."
  value       = local.module_boundaries
}

output "module_catalog" {
  description = "Recommended module boundary to service-name catalog."
  value       = local.module_catalog
}

output "ec2_module_metadata" {
  description = "Metadata returned from the local EC2 module."
  value       = module.ec2.metadata
}
