terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define a list of service objects.
  # Hint: include two objects:
  # { name = "api", ports = [8080, 9090], tags = { tier = "frontend", owner = "platform" } }
  # { name = "worker", ports = [9000], tags = { tier = "backend", owner = "platform" } }
  services = []

  # TODO 2: Count how many service objects are in the list.
  # Hint: use length(local.services).
  service_count = 0

  # TODO 3: Read a nested attribute from the first service object.
  # Hint: use local.services[0].name.
  first_service_name = "TODO-first-service"

  # TODO 4: Read a nested list element from the first service object.
  # Hint: use local.services[0].ports[0].
  api_primary_port = 0

  # TODO 5: Convert the list of objects into a list of names.
  # Hint: use [for service in local.services : service.name].
  service_names = []

  # TODO 6: Flatten all nested port lists into one list.
  # Hint: use flatten([for service in local.services : service.ports]).
  all_ports = []

  # TODO 7: Build "service:port" labels from nested loops.
  # Hint: use flatten with a nested for expression.
  service_port_labels = []

  # TODO 8: Convert the list of objects into a map keyed by service name.
  # Hint: use { for service in local.services : service.name => service }.
  service_by_name = {}

  # TODO 9: Read a nested value through the derived map.
  # Hint: use local.service_by_name["worker"].tags.tier.
  worker_tier = "TODO-tier"
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
