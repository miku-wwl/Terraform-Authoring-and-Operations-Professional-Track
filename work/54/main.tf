terraform {
  required_version = ">= 1.5.0"
}

locals {
  environments = { dev = { region = "local", replicas = 1, zones = ["az-a"], tags = { tier = "test", owner = "platform" } },
    prod = { region = "ap-southeast-2", replicas = 3, zones = ["az-a", "az-b"], tags = { tier = "live", owner = "platform" } }
  }

  environment_count = length(local.environments)

  prod_replicas = local.environments.prod.replicas

  prod_region = local.environments.prod.region

  prod_primary_zone = local.environments.prod.zones[0]

  prod_owner = local.environments.prod.tags.owner

  environment_names = keys(local.environments)

  environment_region_labels = [for name, env in local.environments : "${name}:${env.region}"]
}
resource "terraform_data" "lesson" {
  input = {
    topic        = "nested value reads"
    environments = local.environments
  }
}

output "environments" {
  description = "Complete map of nested environment objects."
  value       = local.environments
}

output "environment_count" {
  description = "Number of environments in the map."
  value       = local.environment_count
}

output "prod_replicas" {
  description = "Replica count read from the nested prod environment object."
  value       = local.prod_replicas
}

output "prod_region" {
  description = "Region read from the nested prod environment object."
  value       = local.prod_region
}

output "prod_primary_zone" {
  description = "First zone read from the prod environment's nested zones list."
  value       = local.prod_primary_zone
}

output "prod_owner" {
  description = "Owner read from the prod environment's nested tags map."
  value       = local.prod_owner
}

output "environment_names" {
  description = "Sorted list of environment names from the map keys."
  value       = local.environment_names
}

output "environment_region_labels" {
  description = "Labels generated from environment names and nested regions."
  value       = local.environment_region_labels
}
