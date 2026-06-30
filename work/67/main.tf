terraform {
  required_version = ">= 1.5.0"
}

locals {
  mock         = jsondecode(file("${path.module}/data/mock.json"))
  backend_apps = [for app in local.mock.apps : app.name if app.tier == "frontend"]
}

output "backend_apps" {
  value = local.backend_apps
}

output "backend_count" {
  value = length(local.backend_apps)
}
