run "conditional_expressions_are_correct" {
  command = plan

  assert {
    condition     = output.environment == "prod"
    error_message = "environment must be prod so the production branches are selected."
  }

  assert {
    condition     = output.enable_backups == true
    error_message = "enable_backups must be true."
  }

  assert {
    condition     = output.replica_count == 3
    error_message = "replica_count must be 3."
  }

  assert {
    condition     = output.instance_size == "large"
    error_message = "instance_size must use local.environment == \"prod\" ? \"large\" : \"small\"."
  }

  assert {
    condition     = output.backup_policy == "daily"
    error_message = "backup_policy must use local.enable_backups ? \"daily\" : \"none\"."
  }

  assert {
    condition     = output.high_availability == true
    error_message = "high_availability must use local.replica_count >= 3 ? true : false."
  }

  assert {
    condition     = output.selected_zones == tolist(["az-a", "az-b"])
    error_message = "selected_zones must choose the production zone list."
  }

  assert {
    condition = output.selected_tags == tomap({
      owner    = "platform"
      env      = "prod"
      critical = "true"
    })
    error_message = "selected_tags must merge the critical tag for production."
  }

  assert {
    condition     = output.enabled_features == ["metrics", "tracing"]
    error_message = "enabled_features must keep only feature flags whose value is true."
  }
}
