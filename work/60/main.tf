terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the CSV file into a list of objects.
  # Hint: use csvdecode(file("${path.module}/data/services.csv")).
  services = []

  # TODO 2: Count how many records are in the CSV.
  # Hint: use length(local.services).
  service_count = 0

  # TODO 3: Read the first service name from the decoded CSV records.
  # Hint: use local.services[0].name.
  first_service_name = "TODO-service"

  # TODO 4: Convert the service port strings into numbers.
  # Hint: use [for service in local.services : tonumber(service.port)].
  service_ports = []

  # TODO 5: Keep only enabled service names.
  # Hint: use [for service in local.services : service.name if service.enabled == "true"].
  enabled_services = []

  # TODO 6: Convert the decoded CSV records into a map keyed by service name.
  # Hint: use { for service in local.services : service.name => service }.
  service_by_name = {}

  # TODO 7: Read billing's port through the derived map and convert it to a number.
  # Hint: use tonumber(local.service_by_name["billing"].port).
  billing_port = 0
}

resource "terraform_data" "lesson" {
  input = {
    topic    = "csvdecode basics"
    services = local.services
  }
}

output "services" {
  description = "Complete list of service objects decoded from CSV."
  value       = local.services
}

output "service_count" {
  description = "Number of records decoded from the CSV file."
  value       = local.service_count
}

output "first_service_name" {
  description = "Name read from the first decoded CSV record."
  value       = local.first_service_name
}

output "service_ports" {
  description = "Service ports converted from CSV strings into numbers."
  value       = local.service_ports
}

output "enabled_services" {
  description = "Names of services whose CSV enabled column is true."
  value       = local.enabled_services
}

output "service_by_name" {
  description = "Map of decoded CSV records keyed by service name."
  value       = local.service_by_name
}

output "billing_port" {
  description = "Billing service port read through the derived service map."
  value       = local.billing_port
}
