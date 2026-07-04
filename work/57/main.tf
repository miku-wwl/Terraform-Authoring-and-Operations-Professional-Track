terraform {
  required_version = ">= 1.5.0"
}

locals {
  service_files = { api = "api service", worker = "worker service", web = "web service" }
}

resource "terraform_data" "service" {
  for_each = local.service_files

  input = {
    name = each.key

    content = each.value

    label = "${each.key}:${each.value}"
  }
}

locals {
  service_keys = keys(local.service_files)

  service_contents = [for service in terraform_data.service : service.output.content]

  service_labels_by_name = { for name, service in terraform_data.service : name => service.output.label }
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
