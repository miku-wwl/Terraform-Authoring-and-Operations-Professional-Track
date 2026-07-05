terraform {
  required_version = ">= 1.5.0"
}

locals {
  service_groups = [
    ["api", "worker"],
    ["api", "billing"],
    ["worker", "search"]
  ]

  all_service_names = flatten(local.service_groups)

  unique_service_names = distinct(local.all_service_names)

  unique_service_count = length(local.unique_service_names)

  service_regions = {
    api     = ["ap-southeast-2", "us-east-1"]
    billing = ["ap-southeast-1", "us-east-1"]
    worker  = ["ap-southeast-2"]
  }

  nested_region_lists = values(local.service_regions)

  unique_regions = distinct(flatten(local.nested_region_lists))

  service_region_labels = flatten([
    for service, regions in local.service_regions : [
      for region in regions : "${service}:${region}"
    ]
  ])
}

resource "terraform_data" "lesson" {
  input = {
    topic          = "flatten and distinct"
    service_groups = local.service_groups
  }
}

output "service_groups" {
  description = "Input nested list of service names."
  value       = local.service_groups
}

output "all_service_names" {
  description = "Flattened list of all service names, including duplicates."
  value       = local.all_service_names
}

output "unique_service_names" {
  description = "Distinct service names after flattening."
  value       = local.unique_service_names
}

output "unique_service_count" {
  description = "Number of distinct service names."
  value       = local.unique_service_count
}

output "nested_region_lists" {
  description = "Region lists read from the service_regions map."
  value       = local.nested_region_lists
}

output "unique_regions" {
  description = "Distinct regions after flattening nested region lists."
  value       = local.unique_regions
}

output "service_region_labels" {
  description = "Flattened service:region labels generated from a map of lists."
  value       = local.service_region_labels
}
