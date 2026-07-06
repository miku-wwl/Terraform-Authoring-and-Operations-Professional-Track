terraform {
  required_version = ">= 1.5.0"
}

locals {
  common_tags = { managed_by = "terraform", standard = "central-service-module" }
}

module "payments_api" {
  source = "./modules/service_template"

  service_name = "payments-api"
  team_name    = "payments"
  environment  = "dev"
  owner        = "platform"
  enabled      = true
  ports        = [8080, 9090]
  extra_tags   = local.common_tags
}

module "commerce_web" {
  source = "./modules/service_template"

  service_name = "commerce-web"
  team_name    = "commerce"
  environment  = "dev"
  owner        = "commerce"
  enabled      = true
  ports        = [3000]
  extra_tags   = local.common_tags
}

module "batch_worker" {
  source = "./modules/service_template"

  service_name = "batch-worker"
  team_name    = "platform"
  environment  = "dev"
  owner        = "platform"
  enabled      = false
  ports        = [9000]
  extra_tags   = local.common_tags
}

locals {
  service_records = [module.payments_api.service_record, module.commerce_web.service_record, module.batch_worker.service_record]

  services_by_name = { for service in local.service_records : service.service_name => service }

  enabled_service_names = [for service in local.service_records : service.service_name if service.enabled]

  all_port_labels = flatten([for service in local.service_records : service.port_labels])
}

resource "terraform_data" "lesson" {
  input = {
    topic          = "terraform modules and dry reuse"
    service_count  = length(local.service_records)
    enabled_count  = length(local.enabled_service_names)
    module_source  = "./modules/service_template"
    module_pattern = "standard template reused by multiple teams"
  }
}

output "service_records" {
  description = "Standardized service records returned by local modules."
  value       = local.service_records
}

output "services_by_name" {
  description = "Service records keyed by service name."
  value       = local.services_by_name
}

output "enabled_service_names" {
  description = "Enabled service names selected from module outputs."
  value       = local.enabled_service_names
}

output "all_port_labels" {
  description = "Flattened service:port labels returned by all module calls."
  value       = local.all_port_labels
}

output "lesson_summary" {
  description = "Summary object for this modules lesson."
  value       = terraform_data.lesson.input
}
