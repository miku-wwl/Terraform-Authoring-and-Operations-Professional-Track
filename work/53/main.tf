terraform {
  required_version = ">= 1.5.0"
}

locals {
  services = [{ name = "api", ports = [8080, 9090], tags = { tier = "frontend", owner = "platform" } },
  { name = "worker", ports = [9000], tags = { tier = "backend", owner = "platform" } }]

  service_count = length(local.services)

  first_service_name = local.services[0].name

  api_primary_port = local.services[0].ports[0]

  service_names = [for service in local.services : service.name]

  all_ports = flatten([for service in local.services : service.ports])

  service_port_labels = flatten([
    for service in local.services : [
      for port in service.ports : "${service.name}:${port}"
    ]
  ])

  service_by_name = { for service in local.services : service.name => service }

  worker_tier = local.service_by_name["worker"].tags.tier
}

resource "terraform_data" "lesson" {
  input = {
    topic    = "nested types"
    services = local.services
  }
}

output "services" {
  description = "Complete list of nested service objects."
  value       = local.services
}

output "service_count" {
  description = "Number of service objects in the list."
  value       = local.service_count
}

output "first_service_name" {
  description = "Service name read from the first object in the list."
  value       = local.first_service_name
}

output "api_primary_port" {
  description = "First port read from the first service object's ports list."
  value       = local.api_primary_port
}

output "service_names" {
  description = "List of names derived from nested service objects."
  value       = local.service_names
}

output "all_ports" {
  description = "Flattened list of all service ports."
  value       = local.all_ports
}

output "service_port_labels" {
  description = "Labels generated from nested service and port loops."
  value       = local.service_port_labels
}

output "service_by_name" {
  description = "Map derived from the service object list and keyed by name."
  value       = local.service_by_name
}

output "worker_tier" {
  description = "Nested tier value read through the derived service map."
  value       = local.worker_tier
}
