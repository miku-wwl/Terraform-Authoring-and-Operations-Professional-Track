terraform {
  required_version = ">= 1.5.0"
}

locals {
  services = [
    { name = "api", tier = "frontend", enabled = true, ports = [8080, 9090] },
    { name = "web", tier = "frontend", enabled = true, ports = [8081] },
    { name = "worker", tier = "backend", enabled = false, ports = [9000] },
    { name = "billing", tier = "backend", enabled = true, ports = [7070] }
  ]

  # TODO 1: Keep only enabled service names.
  # Hint: use [for service in local.services : service.name if service.enabled].
  enabled_service_names = [for service in local.services : service.name if service.enabled]

  # TODO 2: Build a map of enabled services keyed by name.
  # Hint: use { for service in local.services : service.name => service if service.enabled }.
  enabled_service_by_name = { for service in local.services : service.name => service if service.enabled }

  # TODO 3: Group service names by tier.
  # Hint: use { for service in local.services : service.tier => service.name... }.
  service_names_by_tier = { for service in local.services : service.tier => service.name... }

  # TODO 4: Flatten all service ports into "service:port" labels.
  # Hint: use flatten with nested for expressions over services and service.ports.
  service_port_labels = flatten([
    for service in local.services : [
      for port in service.ports : "${service.name}:${port}"
    ]
  ])

  # TODO 5: Build a map from enabled service name to its first port.
  # Hint: use { for service in local.services : service.name => service.ports[0] if service.enabled }.
  enabled_primary_ports = { for service in local.services : service.name => service.ports[0] if service.enabled }

  # TODO 6: Build labels only for enabled services.
  # Hint: use [for service in local.services : "${service.tier}:${service.name}" if service.enabled].
  enabled_tier_labels = [for service in local.services : "${service.tier}:${service.name}" if service.enabled]
}

resource "terraform_data" "lesson" {
  input = {
    topic    = "advanced for expressions"
    services = local.services
  }
}

output "services" {
  description = "Input list of service objects."
  value       = local.services
}

output "enabled_service_names" {
  description = "Names selected with a for expression if clause."
  value       = local.enabled_service_names
}

output "enabled_service_by_name" {
  description = "Map of enabled services keyed by service name."
  value       = local.enabled_service_by_name
}

output "service_names_by_tier" {
  description = "Service names grouped by tier with grouping mode."
  value       = local.service_names_by_tier
}

output "service_port_labels" {
  description = "Flattened service:port labels generated from nested for expressions."
  value       = local.service_port_labels
}

output "enabled_primary_ports" {
  description = "Map of enabled service names to their first port."
  value       = local.enabled_primary_ports
}

output "enabled_tier_labels" {
  description = "Tier:name labels for enabled services."
  value       = local.enabled_tier_labels
}
