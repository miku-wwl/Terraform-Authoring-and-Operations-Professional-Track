run "nested_value_reads_are_correct" {
  command = plan

  assert {
    condition = output.environments == {
      dev = {
        region   = "local"
        replicas = 1
        zones    = ["az-a"]
        tags = {
          tier  = "test"
          owner = "platform"
        }
      }
      prod = {
        region   = "ap-southeast-2"
        replicas = 3
        zones    = ["az-a", "az-b"]
        tags = {
          tier  = "live"
          owner = "platform"
        }
      }
    }
    error_message = "environments must be a map containing nested dev and prod environment objects."
  }

  assert {
    condition     = output.environment_count == 2
    error_message = "environment_count must be calculated with length(local.environments)."
  }

  assert {
    condition     = output.prod_replicas == 3
    error_message = "prod_replicas must read local.environments.prod.replicas."
  }

  assert {
    condition     = output.prod_region == "ap-southeast-2"
    error_message = "prod_region must read local.environments.prod.region."
  }

  assert {
    condition     = output.prod_primary_zone == "az-a"
    error_message = "prod_primary_zone must read local.environments.prod.zones[0]."
  }

  assert {
    condition     = output.prod_owner == "platform"
    error_message = "prod_owner must read local.environments.prod.tags.owner."
  }

  assert {
    condition     = output.environment_names == ["dev", "prod"]
    error_message = "environment_names must be calculated with keys(local.environments)."
  }

  assert {
    condition     = output.environment_region_labels == ["dev:local", "prod:ap-southeast-2"]
    error_message = "environment_region_labels must be derived with a for expression over local.environments."
  }
}
