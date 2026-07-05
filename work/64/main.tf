terraform {
  required_version = ">= 1.5.0"
}

locals {
  service_groups = [
    ["api", "worker"],
    ["api", "billing"],
    ["worker", "search"]
  ]

  # TODO 1: Flatten the nested service name lists into one list.
  # Hint: use flatten(local.service_groups).
  all_service_names = []

  # TODO 2: Remove duplicate service names while preserving first-seen order.
  # Hint: use distinct(local.all_service_names).
  unique_service_names = []

  # TODO 3: Count the unique service names.
  # Hint: use length(local.unique_service_names).
  unique_service_count = 0

  service_regions = {
    api     = ["ap-southeast-2", "us-east-1"]
    billing = ["ap-southeast-1", "us-east-1"]
    worker  = ["ap-southeast-2"]
  }

  # TODO 4: Read the map values as a nested list of region lists.
  # Hint: use values(local.service_regions).
  nested_region_lists = []

  # TODO 5: Flatten the region lists and remove duplicates.
  # Hint: use distinct(flatten(local.nested_region_lists)).
  unique_regions = []

  # TODO 6: Build "service:region" labels from the map of region lists.
  # Hint: use flatten with a nested for expression over service and regions.
  service_region_labels = []
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
