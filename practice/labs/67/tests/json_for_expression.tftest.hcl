run "json_values_are_filtered" {
  command = plan

  assert {
    condition     = output.backend_count == 2
    error_message = "必须从 JSON 中筛选出两个 backend 应用。"
  }
}
