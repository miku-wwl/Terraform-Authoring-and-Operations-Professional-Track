terraform {
  required_version = ">= 1.5.0"
}

locals {
  mock = jsondecode(file("${path.module}/data/mock.json"))

  apps = local.mock.apps

  backend_app_names = [for app in local.apps : app.name if app.tier == "backend"]

  enabled_apps_by_name = { for app in local.apps : app.name => app if app.enabled }

  app_owner_labels = [for app in local.apps : "${app.name}:${app.owner}"]

  app_port_labels = flatten([for app in local.apps : [
    for port in app.ports : "${app.name}:${port}"
    ]
  ])
}

resource "terraform_data" "lesson" {
  input = {
    topic = "json mock data and for expressions"
    apps  = local.apps
  }
}

output "apps" {
  description = "Apps decoded from data/mock.json."
  value       = local.apps
}

output "backend_app_names" {
  description = "Backend app names selected from decoded JSON."
  value       = local.backend_app_names
}

output "backend_count" {
  description = "Number of backend apps."
  value       = length(local.backend_app_names)
}

output "enabled_apps_by_name" {
  description = "Enabled apps keyed by app name."
  value       = local.enabled_apps_by_name
}

output "app_owner_labels" {
  description = "App owner labels generated from decoded JSON."
  value       = local.app_owner_labels
}

output "app_port_labels" {
  description = "Flattened app:port labels generated from decoded JSON."
  value       = local.app_port_labels
}
