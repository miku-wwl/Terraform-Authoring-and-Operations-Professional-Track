run "nested_for_expressions_are_correct" {
  command = plan

  assert {
    condition     = output.region_app_labels == ["local-a-api", "local-a-worker", "local-b-api", "local-b-worker"]
    error_message = "region_app_labels must contain every region/app pair."
  }

  assert {
    condition = output.region_app_objects == [
      {
        region = "local-a"
        app    = "api"
        name   = "local-a-api"
      },
      {
        region = "local-a"
        app    = "worker"
        name   = "local-a-worker"
      },
      {
        region = "local-b"
        app    = "api"
        name   = "local-b-api"
      },
      {
        region = "local-b"
        app    = "worker"
        name   = "local-b-worker"
      }
    ]
    error_message = "region_app_objects must contain one object per region/app pair."
  }

  assert {
    condition     = output.worker_region_labels == ["local-a-worker", "local-b-worker"]
    error_message = "worker_region_labels must keep only worker app labels."
  }

  assert {
    condition = output.region_app_by_name == {
      "local-a-api" = {
        region = "local-a"
        app    = "api"
        name   = "local-a-api"
      }
      "local-a-worker" = {
        region = "local-a"
        app    = "worker"
        name   = "local-a-worker"
      }
      "local-b-api" = {
        region = "local-b"
        app    = "api"
        name   = "local-b-api"
      }
      "local-b-worker" = {
        region = "local-b"
        app    = "worker"
        name   = "local-b-worker"
      }
    }
    error_message = "region_app_by_name must map each generated name to its region/app object."
  }

  assert {
    condition     = output.service_labels_by_region == ["local-a:api", "local-a:worker", "local-b:api"]
    error_message = "service_labels_by_region must flatten the services_by_region map."
  }

  assert {
    condition = output.service_map_by_path == {
      "local-a/api"    = { region = "local-a", service = "api" }
      "local-a/worker" = { region = "local-a", service = "worker" }
      "local-b/api"    = { region = "local-b", service = "api" }
    }
    error_message = "service_map_by_path must flatten services_by_region into a map keyed by region/service."
  }
}
