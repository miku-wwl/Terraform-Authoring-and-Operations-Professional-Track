terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define common tags shared by every service module call.
  # Hint: use managed_by = "terraform" and standard = "central-service-module".
  common_tags = {}
}

module "payments_api" {
  source = "./modules/service_template"

  # TODO 2: Fill in this team's module input values.
  # Hint: service_name = "payments-api", team_name = "payments", environment = "dev",
  # owner = "platform", enabled = true, ports = [8080, 9090].
  service_name = ""
  team_name    = ""
  environment  = ""
  owner        = ""
  enabled      = false
  ports        = []
  extra_tags   = local.common_tags
}

module "commerce_web" {
  source = "./modules/service_template"

  # TODO 3: Fill in this team's module input values.
  # Hint: service_name = "commerce-web", team_name = "commerce", environment = "dev",
  # owner = "commerce", enabled = true, ports = [3000].
  service_name = ""
  team_name    = ""
  environment  = ""
  owner        = ""
  enabled      = false
  ports        = []
  extra_tags   = local.common_tags
}

module "batch_worker" {
  source = "./modules/service_template"

  # TODO 4: Fill in this team's module input values.
  # Hint: service_name = "batch-worker", team_name = "platform", environment = "dev",
  # owner = "platform", enabled = false, ports = [9000].
  service_name = ""
  team_name    = ""
  environment  = ""
  owner        = ""
  enabled      = false
  ports        = []
  extra_tags   = local.common_tags
}

locals {
  # TODO 7: Collect service_record outputs from all three module calls.
  # Hint: [module.payments_api.service_record, module.commerce_web.service_record, module.batch_worker.service_record]
  service_records = []

  # TODO 8a: Build a map keyed by service_name.
  # Hint: { for service in local.service_records : service.service_name => service }
  services_by_name = {}

  # TODO 8b: Select only enabled service names.
  # Hint: [for service in local.service_records : service.service_name if service.enabled]
  enabled_service_names = []

  # TODO 8c: Flatten all module-generated port labels.
  # Hint: flatten([for service in local.service_records : service.port_labels])
  all_port_labels = []
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
