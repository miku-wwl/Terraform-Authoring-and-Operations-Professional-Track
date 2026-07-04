run "nested_type_expressions_are_correct" {
  command = plan

  assert {
    condition = output.services == [
      {
        name  = "api"
        ports = [8080, 9090]
        tags = {
          tier  = "frontend"
          owner = "platform"
        }
      },
      {
        name  = "worker"
        ports = [9000]
        tags = {
          tier  = "backend"
          owner = "platform"
        }
      }
    ]
    error_message = "services must be a list containing the api and worker service objects."
  }

  assert {
    condition     = output.service_count == 2
    error_message = "service_count must be calculated with length(local.services)."
  }

  assert {
    condition     = output.first_service_name == "api"
    error_message = "first_service_name must read local.services[0].name."
  }

  assert {
    condition     = output.api_primary_port == 8080
    error_message = "api_primary_port must read local.services[0].ports[0]."
  }

  assert {
    condition     = output.service_names == ["api", "worker"]
    error_message = "service_names must be derived with a for expression over local.services."
  }

  assert {
    condition     = output.all_ports == [8080, 9090, 9000]
    error_message = "all_ports must flatten the nested ports lists."
  }

  assert {
    condition     = output.service_port_labels == ["api:8080", "api:9090", "worker:9000"]
    error_message = "service_port_labels must be built from nested for expressions."
  }

  assert {
    condition = output.service_by_name == {
      api = {
        name  = "api"
        ports = [8080, 9090]
        tags = {
          tier  = "frontend"
          owner = "platform"
        }
      }
      worker = {
        name  = "worker"
        ports = [9000]
        tags = {
          tier  = "backend"
          owner = "platform"
        }
      }
    }
    error_message = "service_by_name must convert the service list into a map keyed by service name."
  }

  assert {
    condition     = output.worker_tier == "backend"
    error_message = "worker_tier must read local.service_by_name[\"worker\"].tags.tier."
  }
}
