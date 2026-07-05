terraform {
  required_version = ">= 1.5.0"
}

locals {
  regions = ["local-a", "local-b"]
  apps    = ["api", "worker"]

  region_app_labels = flatten([
    for region in local.regions : [
      for app in local.apps : "${region}-${app}"
    ]
  ])

  region_app_objects = flatten([
    for region in local.regions : [
      for app in local.apps : {
        region = region
        app    = app
        name   = "${region}-${app}"
      }
    ]
  ])

  worker_region_labels = flatten([
    for region in local.regions : [
      for app in local.apps : "${region}-${app}" if app == "worker"
    ]
  ])

  region_app_by_name = { for item in local.region_app_objects : item.name => item }

  services_by_region = {
    "local-a" = ["api", "worker"]
    "local-b" = ["api"]
  }

  service_labels_by_region = flatten([
    for region, services in local.services_by_region : [
      for service in services : "${region}:${service}"
    ]
  ])

  service_map_by_path = merge([
    for region, services in local.services_by_region : {
      for service in services : "${region}/${service}" => {
        region  = region
        service = service
      }
    }
  ]...)
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
