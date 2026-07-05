run "csvdecode_expressions_are_correct" {
  command = plan

  assert {
    condition = output.services == tolist([
      {
        name    = "api"
        port    = "8080"
        enabled = "true"
      },
      {
        name    = "worker"
        port    = "9000"
        enabled = "false"
      },
      {
        name    = "billing"
        port    = "7070"
        enabled = "true"
      }
    ])
    error_message = "services must decode all records from data/services.csv."
  }

  assert {
    condition     = output.service_count == 3
    error_message = "service_count must be calculated with length(local.services)."
  }

  assert {
    condition     = output.first_service_name == "api"
    error_message = "first_service_name must read local.services[0].name."
  }

  assert {
    condition     = output.service_ports == [8080, 9000, 7070]
    error_message = "service_ports must convert CSV port strings into numbers."
  }

  assert {
    condition     = output.enabled_services == ["api", "billing"]
    error_message = "enabled_services must include only records whose enabled value is \"true\"."
  }

  assert {
    condition = output.service_by_name == {
      api = {
        name    = "api"
        port    = "8080"
        enabled = "true"
      }
      worker = {
        name    = "worker"
        port    = "9000"
        enabled = "false"
      }
      billing = {
        name    = "billing"
        port    = "7070"
        enabled = "true"
      }
    }
    error_message = "service_by_name must convert decoded CSV records into a map keyed by service name."
  }

  assert {
    condition     = output.billing_port == 7070
    error_message = "billing_port must read billing's port from service_by_name and convert it to a number."
  }
}
