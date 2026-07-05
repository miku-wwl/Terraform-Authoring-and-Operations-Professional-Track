terraform {
  required_version = ">= 1.5.0"
}

locals {
  applications = [
    {
      name        = "checkout"
      team        = "payments"
      environment = "prod"
      regions     = ["ap-southeast-2", "us-east-1"]
      enabled     = true
    },
    {
      name        = "ledger"
      team        = "payments"
      environment = "dev"
      regions     = ["ap-southeast-2"]
      enabled     = false
    },
    {
      name        = "catalog"
      team        = "commerce"
      environment = "prod"
      regions     = ["ap-southeast-1", "eu-west-1"]
      enabled     = true
    }
  ]

  prod_application_names = [for app in local.applications : app.name if app.environment == "prod"]

  enabled_applications = { for app in local.applications : app.name => app if app.enabled }

  application_names_by_team = { for app in local.applications : app.team => app.name... }

  application_region_labels = flatten([
    for app in local.applications : [
      for region in app.regions : "${app.name}:${region}"
    ]
  ])

  enabled_prod_primary_regions = { for app in local.applications : app.name => app.regions[0] if app.enabled && app.environment == "prod" }

  application_environment_by_path = { for app in local.applications : "${app.team}/${app.name}" => app.environment }
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "advanced for expressions"
    applications = local.applications
  }
}

output "applications" {
  description = "Input list of application objects."
  value       = local.applications
}

output "prod_application_names" {
  description = "Production application names selected with a for expression filter."
  value       = local.prod_application_names
}

output "enabled_applications" {
  description = "Enabled applications keyed by application name."
  value       = local.enabled_applications
}

output "application_names_by_team" {
  description = "Application names grouped by team."
  value       = local.application_names_by_team
}

output "application_region_labels" {
  description = "Flattened app:region labels generated from nested for expressions."
  value       = local.application_region_labels
}

output "enabled_prod_primary_regions" {
  description = "Primary regions for enabled production applications."
  value       = local.enabled_prod_primary_regions
}

output "application_environment_by_path" {
  description = "Application environment map keyed by team/name path."
  value       = local.application_environment_by_path
}
