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
  service_config = { name = "payments", environment = "dev", owner = "platform" }

  rendered_service_config = templatefile("${path.module}/template.tftpl", local.service_config)

  rendered_file_path = "${path.module}/output/service.txt"

  rendered_preview = split("\n", trimspace(local.rendered_service_config))[0]
}

resource "local_file" "rendered" {
  filename = local.rendered_file_path
  content  = local.rendered_service_config
}

output "service_config" {
  description = "Values passed into templatefile()."
  value       = local.service_config
}

output "rendered_service_config" {
  description = "Rendered template content."
  value       = local.rendered_service_config
}

output "rendered_file_path" {
  description = "Path where the rendered template is written."
  value       = local.rendered_file_path
}

output "rendered_preview" {
  description = "First line of the rendered template."
  value       = local.rendered_preview
}
