terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  # TODO 1: Define a service port map.
  # Hint: include api = 8080, worker = 9000, and billing = 7070.
  service_ports = {}

  # TODO 2: Get service names from the map.
  # Hint: use keys(local.service_ports).
  service_names = []

  # TODO 3: Render the services template with the map and names.
  # Hint: pass services = local.service_ports and names = local.service_names.
  rendered_services = ""

  # TODO 4: Build the output file path.
  # Hint: use "${path.module}/output/services.txt".
  rendered_file_path = ""

  # TODO 5: Read the rendered lines as a list.
  # Hint: use split("\n", trimspace(local.rendered_services)).
  rendered_lines = []
}

resource "local_file" "rendered" {
  filename = local.rendered_file_path
  content  = local.rendered_services
}

output "service_ports" {
  description = "Input service port map passed into the template."
  value       = local.service_ports
}

output "service_names" {
  description = "Sorted service names from the map keys."
  value       = local.service_names
}

output "rendered_services" {
  description = "Rendered template content generated from the service map."
  value       = local.rendered_services
}

output "rendered_file_path" {
  description = "Path where the rendered services file is written."
  value       = local.rendered_file_path
}

output "rendered_lines" {
  description = "Rendered template content split into lines."
  value       = local.rendered_lines
}
