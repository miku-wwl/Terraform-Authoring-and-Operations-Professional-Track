run "json_decode_selects_nested_values" {
  command = plan

  assert {
    condition     = output.backend_service_name == "payments"
    error_message = "必须筛选出 backend 服务 payments。"
  }

  assert {
    condition     = output.first_backend_port == 8080
    error_message = "必须能通过索引读取嵌套数组中的第一个端口。"
  }

  assert {
    condition     = output.backend_port_count == 2
    error_message = "backend 服务应包含两个端口。"
  }
}
