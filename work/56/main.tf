terraform {
  required_version = ">= 1.5.0"
}

locals {
  service_ports = { api = 8080, worker = 9000, web = 8081 }

  api_port = local.service_ports["api"]

  service_count = length(local.service_ports)

  service_names = keys(local.service_ports)

  port_numbers = values(local.service_ports)

  admin_port = lookup(local.service_ports, "admin", 7000)

  service_port_labels = [for name, port in local.service_ports : "${name}:${port}"]
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
