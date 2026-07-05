terraform {
  required_version = ">= 1.5.0"
}

locals {
  regions = ["local-a", "local-b"]
  apps    = ["api", "worker"]

  # TODO 1: Build every region/app label with nested for expressions.
  # Hint: use flatten([for region in local.regions : [for app in local.apps : "${region}-${app}"]]).
  region_app_labels = []

  # TODO 2: Build every region/app object with nested for expressions.
  # Hint: each object should have region, app, and name = "${region}-${app}".
  region_app_objects = []

  # TODO 3: Build labels only for worker app deployments.
  # Hint: use nested for expressions and an if clause on app == "worker".
  worker_region_labels = []

  # TODO 4: Convert the region/app objects into a map keyed by name.
  # Hint: use { for item in local.region_app_objects : item.name => item }.
  region_app_by_name = {}

  services_by_region = {
    "local-a" = ["api", "worker"]
    "local-b" = ["api"]
  }

  # TODO 5: Flatten services_by_region into "region:service" labels.
  # Hint: use nested for expressions over region, services and service.
  service_labels_by_region = []

  # TODO 6: Convert services_by_region into a flat map keyed by "region/service".
  # Hint: use merge with a splat expansion over a list of maps.
  service_map_by_path = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic   = "nested for expressions"
    regions = local.regions
    apps    = local.apps
  }
}

output "regions" {
  description = "Input region list."
  value       = local.regions
}

output "apps" {
  description = "Input app list."
  value       = local.apps
}

output "region_app_labels" {
  description = "All region/app labels generated with nested for expressions."
  value       = local.region_app_labels
}

output "region_app_objects" {
  description = "All region/app objects generated with nested for expressions."
  value       = local.region_app_objects
}

output "worker_region_labels" {
  description = "Only worker app labels generated with nested for expressions and if filtering."
  value       = local.worker_region_labels
}

output "region_app_by_name" {
  description = "Region/app objects keyed by generated name."
  value       = local.region_app_by_name
}

output "service_labels_by_region" {
  description = "Flattened region:service labels from a map of lists."
  value       = local.service_labels_by_region
}

output "service_map_by_path" {
  description = "Flat map keyed by region/service path."
  value       = local.service_map_by_path
}
