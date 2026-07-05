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
  # TODO 1: Define the values passed into the template.
  # Hint: include name = "payments", environment = "dev", and owner = "platform".
  service_config = {}

  # TODO 2: Render template.tftpl with templatefile().
  # Hint: use templatefile("${path.module}/template.tftpl", local.service_config).
  rendered_service_config = ""

  # TODO 3: Build a file path under the module output directory.
  # Hint: use "${path.module}/output/service.txt".
  rendered_file_path = ""

  # TODO 4: Build a short preview from the rendered template lines.
  # Hint: use split("\n", trimspace(local.rendered_service_config))[0].
  rendered_preview = ""
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
