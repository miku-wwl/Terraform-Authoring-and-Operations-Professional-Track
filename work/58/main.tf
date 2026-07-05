terraform {
  required_version = ">= 1.5.0"
}

locals {
  environment = "prod"

  enable_backups = true

  replica_count = 3

  instance_size = local.environment == "prod" ? "large" : "small"

  backup_policy = local.enable_backups ? "daily" : "none"

  high_availability = local.replica_count >= 3 ? true : false

  selected_zones = local.environment == "prod" ? ["az-a", "az-b"] : ["az-a"]

  base_tags = {
    owner = "platform"
    env   = local.environment
  }
  selected_tags = local.environment == "prod" ? merge(local.base_tags, { critical = "true" }) : local.base_tags

  feature_flags = {
    metrics = true
    tracing = true
    debug   = false
  }
  enabled_features = [for name, enabled in local.feature_flags : name if enabled]
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
