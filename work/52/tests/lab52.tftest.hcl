run "object_expressions_are_correct" {
  command = plan

  assert {
    condition = output.service == {
      name    = "payments"
      port    = 8080
      enabled = true
      tags = {
        owner = "platform"
        env   = "dev"
      }
      zones = ["az-a", "az-b"]
    }
    error_message = "service 必须是包含 name、port、enabled、tags、zones 的 object。"
  }

  assert {
    condition     = output.service_name == "payments"
    error_message = "service_name 必须通过 local.service.name 读取。"
  }

  assert {
    condition     = output.service_port == 8080
    error_message = "service_port 必须通过 local.service.port 读取。"
  }

  assert {
    condition     = output.service_enabled == true
    error_message = "service_enabled 必须通过 local.service.enabled 读取。"
  }

  assert {
    condition     = output.service_owner == "platform"
    error_message = "service_owner 必须通过 local.service.tags.owner 读取。"
  }

  assert {
    condition     = output.primary_zone == "az-a"
    error_message = "primary_zone 必须通过 local.service.zones[0] 读取。"
  }

  assert {
    condition     = output.service_endpoint == "payments:8080"
    error_message = "service_endpoint 必须由 service name 和 port 拼接得到。"
  }
}
