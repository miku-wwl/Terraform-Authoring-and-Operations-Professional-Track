run "map_expressions_are_correct" {
  command = plan

  assert {
    condition = output.service_ports == {
      api    = 8080
      worker = 9000
      web    = 8081
    }
    error_message = "service_ports must be a map containing api, worker, and web ports."
  }

  assert {
    condition     = output.api_port == 8080
    error_message = "api_port must read local.service_ports[\"api\"]."
  }

  assert {
    condition     = output.service_count == 3
    error_message = "service_count must be calculated with length(local.service_ports)."
  }

  assert {
    condition     = output.service_names == ["api", "web", "worker"]
    error_message = "service_names must be calculated with keys(local.service_ports)."
  }

  assert {
    condition     = output.port_numbers == [8080, 8081, 9000]
    error_message = "port_numbers must be calculated with values(local.service_ports)."
  }

  assert {
    condition     = output.admin_port == 7000
    error_message = "admin_port must use lookup(local.service_ports, \"admin\", 7000)."
  }

  assert {
    condition     = output.service_port_labels == ["api:8080", "web:8081", "worker:9000"]
    error_message = "service_port_labels must be generated with a for expression over the map."
  }
}
