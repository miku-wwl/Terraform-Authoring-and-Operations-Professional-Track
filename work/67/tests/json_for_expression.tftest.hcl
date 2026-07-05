run "json_mock_for_expressions_are_correct" {
  command = plan

  assert {
    condition     = length(output.apps) == 4
    error_message = "apps must decode all app objects from data/mock.json."
  }

  assert {
    condition     = output.backend_app_names == ["api", "worker", "billing"]
    error_message = "backend_app_names must select app names where tier is backend."
  }

  assert {
    condition     = output.backend_count == 3
    error_message = "backend_count must count backend apps."
  }

  assert {
    condition = output.enabled_apps_by_name == {
      api = {
        name    = "api"
        tier    = "backend"
        owner   = "platform"
        enabled = true
        ports   = [8080, 9090]
      }
      web = {
        name    = "web"
        tier    = "frontend"
        owner   = "commerce"
        enabled = true
        ports   = [3000]
      }
      billing = {
        name    = "billing"
        tier    = "backend"
        owner   = "payments"
        enabled = true
        ports   = [7070]
      }
    }
    error_message = "enabled_apps_by_name must keep only enabled apps keyed by name."
  }

  assert {
    condition = output.app_owner_labels == [
      "api:platform",
      "web:commerce",
      "worker:platform",
      "billing:payments"
    ]
    error_message = "app_owner_labels must build app:owner labels from JSON apps."
  }

  assert {
    condition = output.app_port_labels == [
      "api:8080",
      "api:9090",
      "web:3000",
      "worker:9000",
      "billing:7070"
    ]
    error_message = "app_port_labels must flatten app ports into app:port labels."
  }
}
