terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define a map from service name to port number.
  # Hint: use api = 8080, worker = 9000, web = 8081.
  service_ports = {}

  # TODO 2: Read one map value by key.
  # Hint: use local.service_ports["api"].
  api_port = 0

  # TODO 3: Count how many services are in the map.
  # Hint: use length(local.service_ports).
  service_count = 0

  # TODO 4: Get the sorted list of service names.
  # Hint: use keys(local.service_ports).
  service_names = []

  # TODO 5: Get the list of service port numbers.
  # Hint: use values(local.service_ports).
  port_numbers = []

  # TODO 6: Read an optional service port with a fallback value.
  # Hint: use lookup(local.service_ports, "admin", 7000).
  admin_port = 0

  # TODO 7: Convert the map into "service:port" labels.
  # Hint: use [for name, port in local.service_ports : "${name}:${port}"].
  service_port_labels = []
}

resource "terraform_data" "lesson" {
  input = {
    topic         = "map data type"
    service_ports = local.service_ports
  }
}

output "service_ports" {
  description = "Complete map from service names to port numbers."
  value       = local.service_ports
}

output "api_port" {
  description = "Port read by map key for the api service."
  value       = local.api_port
}

output "service_count" {
  description = "Number of service entries in the map."
  value       = local.service_count
}

output "service_names" {
  description = "Sorted list of service names from map keys."
  value       = local.service_names
}

output "port_numbers" {
  description = "List of service port numbers from map values."
  value       = local.port_numbers
}

output "admin_port" {
  description = "Optional admin port read with lookup fallback."
  value       = local.admin_port
}

output "service_port_labels" {
  description = "Labels generated from service name and port pairs."
  value       = local.service_port_labels
}
