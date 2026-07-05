run "advanced_for_expressions_are_correct" {
  command = plan

  assert {
    condition     = output.enabled_service_names == ["api", "web", "billing"]
    error_message = "enabled_service_names must keep only services whose enabled value is true."
  }

  assert {
    condition = output.enabled_service_by_name == {
      api = {
        name    = "api"
        tier    = "frontend"
        enabled = true
        ports   = [8080, 9090]
      }
      web = {
        name    = "web"
        tier    = "frontend"
        enabled = true
        ports   = [8081]
      }
      billing = {
        name    = "billing"
        tier    = "backend"
        enabled = true
        ports   = [7070]
      }
    }
    error_message = "enabled_service_by_name must build a map of only enabled services."
  }

  assert {
    condition = output.service_names_by_tier == {
      backend  = ["worker", "billing"]
      frontend = ["api", "web"]
    }
    error_message = "service_names_by_tier must group service names by tier using grouping mode."
  }

  assert {
    condition     = output.service_port_labels == ["api:8080", "api:9090", "web:8081", "worker:9000", "billing:7070"]
    error_message = "service_port_labels must flatten nested service port lists."
  }

  assert {
    condition = output.enabled_primary_ports == {
      api     = 8080
      web     = 8081
      billing = 7070
    }
    error_message = "enabled_primary_ports must map enabled service names to their first port."
  }

  assert {
    condition     = output.enabled_tier_labels == ["frontend:api", "frontend:web", "backend:billing"]
    error_message = "enabled_tier_labels must build tier:name labels only for enabled services."
  }
}
