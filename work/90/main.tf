terraform {
  required_version = ">= 1.5.0"
}

module "service" {
  # TODO 1: Replace this placeholder source with the real local module path.
  # Hint: use ./modules/service_blueprint.
  source = "./modules/placeholder"

  # TODO 2: Pass service_name = "payments-api" to the module.
  # Hint: service_name = "payments-api".
  service_name = "todo-service"

  # TODO 3: Pass environment = "prod" to the module.
  # Hint: environment = "prod".
  environment = "dev"

  # TODO 4: Pass owner = "platform" to the module.
  # Hint: owner = "platform".
  owner = "unknown"
}

locals {
  # These examples are static strings so you can compare common source formats
  # without depending on network access in this lab.
  source_examples = {
    local_path       = "./modules/service_blueprint"
    registry         = "hashicorp/consul/aws"
    github           = "github.com/example-org/example-module"
    generic_git      = "git::https://example.com/org/example-module.git"
    http_archive     = "https://example.com/modules/example-module.zip"
    s3_archive       = "s3::https://s3.amazonaws.com/example-bucket/example-module.zip"
    registry_version = "version = 1.2.0"
  }

  # TODO 5: Read service_id from the child module output.
  # Hint: use module.service.service_id.
  service_id = ""

  # TODO 6: Read module_source_style from the child module output.
  # Hint: use module.service.module_source_style.
  module_source_style = ""
}

resource "terraform_data" "lesson" {
  input = {
    topic               = "module sources and source argument"
    service_id          = local.service_id
    module_source_style = local.module_source_style
  }
}

output "service_id" {
  description = "Service id returned by the child module."
  value       = local.service_id
}

output "service_summary" {
  description = "Service summary returned by the child module."
  value       = module.service.service_summary
}

output "module_source_style" {
  description = "Module source style returned by the child module."
  value       = local.module_source_style
}

output "source_examples" {
  description = "Common module source formats for comparison."
  value       = local.source_examples
}
