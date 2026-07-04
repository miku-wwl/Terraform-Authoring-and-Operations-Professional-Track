terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Set the active environment.
  # Hint: use "prod" so the production branches are selected.
  environment = "dev"

  # TODO 2: Set whether backups are enabled.
  # Hint: use true.
  enable_backups = false

  # TODO 3: Set the desired replica count.
  # Hint: use 3.
  replica_count = 1

  # TODO 4: Choose an instance size with a conditional expression.
  # Hint: use local.environment == "prod" ? "large" : "small".
  instance_size = "TODO-size"

  # TODO 5: Choose a backup policy with a boolean conditional.
  # Hint: use local.enable_backups ? "daily" : "none".
  backup_policy = "TODO-policy"

  # TODO 6: Choose a high availability flag from a number comparison.
  # Hint: use local.replica_count >= 3 ? true : false.
  high_availability = false

  # TODO 7: Choose a list of zones based on the environment.
  # Hint: prod should use ["az-a", "az-b"], otherwise use ["az-a"].
  selected_zones = []

  # TODO 8: Choose tags based on whether this is production.
  # Hint: prod should merge { critical = "true" } into the base tags.
  base_tags = {
    owner = "platform"
    env   = local.environment
  }
  selected_tags = {}

  # TODO 9: Keep only enabled features with an if clause in a for expression.
  # Hint: use [for name, enabled in local.feature_flags : name if enabled].
  feature_flags = {
    metrics = true
    tracing = true
    debug   = false
  }
  enabled_features = []
}

resource "terraform_data" "lesson" {
  input = {
    topic       = "conditional expressions"
    environment = local.environment
  }
}

output "environment" {
  description = "Active environment used by conditional expressions."
  value       = local.environment
}

output "enable_backups" {
  description = "Boolean input used by a conditional expression."
  value       = local.enable_backups
}

output "replica_count" {
  description = "Number input used by a conditional expression."
  value       = local.replica_count
}

output "instance_size" {
  description = "Instance size selected from environment."
  value       = local.instance_size
}

output "backup_policy" {
  description = "Backup policy selected from a boolean condition."
  value       = local.backup_policy
}

output "high_availability" {
  description = "High availability flag selected from replica count."
  value       = local.high_availability
}

output "selected_zones" {
  description = "Zone list selected from environment."
  value       = local.selected_zones
}

output "selected_tags" {
  description = "Tags selected and merged based on environment."
  value       = local.selected_tags
}

output "enabled_features" {
  description = "Feature names selected with a for expression if clause."
  value       = local.enabled_features
}
