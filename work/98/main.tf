terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the architecture mock file.
  # Hint: use jsondecode(file("${path.module}/data/module_architecture.json")).
  architecture = {}

  # TODO 2: Read the services list from requested_architecture.
  # Hint: use local.architecture.requested_architecture.services.
  services = []

  # TODO 3: Define the minimal recommended files for a reusable module.
  # Hint: use toset(["README.md", "main.tf", "variables.tf", "outputs.tf"]).
  standard_required_files = toset([])

  # TODO 4: Detect files inside the local EC2 module directory.
  # Hint: use toset(fileset("${path.module}/modules/ec2", "*")).
  ec2_module_files = toset([])

  # TODO 5: Calculate which required module files are missing.
  # Hint: use setsubtract(local.standard_required_files, local.ec2_module_files).
  missing_required_files = toset([])

  # TODO 6: Build a sorted list of unique module boundaries from services.
  # Hint: use sort(tolist(toset([for service in local.services : service.module_boundary]))).
  module_boundaries = []

  # TODO 7: Build a catalog where each boundary maps to its service names.
  # Hint:
  # {
  #   for boundary in local.module_boundaries : boundary => [
  #     for service in local.services : service.name
  #     if service.module_boundary == boundary
  #   ]
  # }
  module_catalog = {}
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
    topic                  = "standard module structure"
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
