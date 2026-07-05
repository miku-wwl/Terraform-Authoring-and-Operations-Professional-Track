terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the JSON mock file.
  # Hint: use jsondecode(file("${path.module}/data/mock.json")).
  mock = {}

  # TODO 2: Read the apps list from the decoded JSON object.
  # Hint: use local.mock.apps.
  apps = []

  # TODO 3: Select the names of backend apps.
  # Hint: use a for expression with if app.tier == "backend".
  backend_app_names = []

  # TODO 4: Build a map of enabled apps keyed by app name.
  # Hint: use { for app in local.apps : app.name => app if app.enabled }.
  enabled_apps_by_name = {}

  # TODO 5: Build app owner labels like "api:platform".
  # Hint: use [for app in local.apps : "${app.name}:${app.owner}"].
  app_owner_labels = []

  # TODO 6: Flatten every app port into "app:port" labels.
  # Hint: use flatten with nested for expressions over apps and app.ports.
  app_port_labels = []
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
