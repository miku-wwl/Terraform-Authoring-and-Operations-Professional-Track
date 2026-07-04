terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define a map of service descriptions for for_each.
  # Hint: use api = "api service", worker = "worker service", web = "web service".
  service_files = {}
}

resource "terraform_data" "service" {
  # TODO 2: Create one terraform_data instance per service map entry.
  # Hint: use for_each = local.service_files.
  for_each = {}

  input = {
    # TODO 3: Store the current map key.
    # Hint: use each.key.
    name = "TODO-name"

    # TODO 4: Store the current map value.
    # Hint: use each.value.
    content = "TODO-content"

    # TODO 5: Build a stable label from the key and value.
    # Hint: use "${each.key}:${each.value}".
    label = "TODO-label"
  }
}

locals {
  # TODO 6: Get the sorted list of service keys.
  # Hint: use keys(local.service_files).
  service_keys = []

  # TODO 7: Collect content values from all for_each-created instances.
  # Hint: use [for service in terraform_data.service : service.output.content].
  service_contents = []

  # TODO 8: Build a map of labels from all for_each-created instances.
  # Hint: use { for name, service in terraform_data.service : name => service.output.label }.
  service_labels_by_name = {}
}

output "service_files" {
  description = "Input map used by for_each."
  value       = local.service_files
}

output "service_count" {
  description = "Number of services in the input map."
  value       = length(local.service_files)
}

output "resource_count" {
  description = "Number of terraform_data.service instances created with for_each."
  value       = length(terraform_data.service)
}

output "service_keys" {
  description = "Sorted service keys from the input map."
  value       = local.service_keys
}

output "api_content" {
  description = "Content read from the api for_each resource instance."
  value       = terraform_data.service["api"].output.content
}

output "worker_name" {
  description = "Name read from the worker for_each resource instance."
  value       = terraform_data.service["worker"].output.name
}

output "service_contents" {
  description = "Contents collected from all for_each-created instances."
  value       = local.service_contents
}

output "service_labels_by_name" {
  description = "Labels collected from all for_each-created instances and keyed by service name."
  value       = local.service_labels_by_name
}
