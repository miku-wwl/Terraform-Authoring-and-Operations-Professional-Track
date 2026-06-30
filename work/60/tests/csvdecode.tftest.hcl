run "csvdecode_reads_records" {
  command = plan

  assert {
    condition     = output.service_count == 3
    error_message = "CSV 应包含三条服务记录。"
  }

  assert {
    condition     = contains(output.enabled_services, "api")
    error_message = "必须筛选出启用的 api 服务。"
  }
}
