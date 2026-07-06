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
  service_ports = { api = 8080, worker = 9000, billing = 7070 }

  service_names = keys(local.service_ports)

  rendered_services = templatefile("${path.module}/template.tftpl", {
    services = local.service_ports
    names    = local.service_names
  })

  rendered_file_path = "${path.module}/output/services.txt"

  rendered_lines = split("\n", trimspace(local.rendered_services))
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

output "rendered_file_content" {
  description = "Content written by the local_file resource."

  value = local_file.rendered.content
}

output "rendered_lines" {
  description = "Rendered template content split into lines."
  value       = local.rendered_lines
}
