terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define a map of environment objects.
  # Hint: include dev and prod:
  # dev = { region = "local", replicas = 1, zones = ["az-a"], tags = { tier = "test", owner = "platform" } }
  # prod = { region = "ap-southeast-2", replicas = 3, zones = ["az-a", "az-b"], tags = { tier = "live", owner = "platform" } }
  environments = {}

  # TODO 2: Count how many environments are in the map.
  # Hint: use length(local.environments).
  environment_count = 0

  # TODO 3: Read a nested number value from the prod environment.
  # Hint: use local.environments.prod.replicas.
  prod_replicas = 0

  # TODO 4: Read a nested string value from the prod environment.
  # Hint: use local.environments.prod.region.
  prod_region = "TODO-region"

  # TODO 5: Read the first element from a nested zones list.
  # Hint: use local.environments.prod.zones[0].
  prod_primary_zone = "TODO-zone"

  # TODO 6: Read a nested tag value from the prod environment.
  # Hint: use local.environments.prod.tags.owner.
  prod_owner = "TODO-owner"

  # TODO 7: Get the sorted list of environment names.
  # Hint: use keys(local.environments).
  environment_names = []

  # TODO 8: Build "environment:region" labels from the nested map.
  # Hint: use [for name, env in local.environments : "${name}:${env.region}"].
  environment_region_labels = []
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
