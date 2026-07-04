run "starter_shape_is_valid" {
  command = plan

  assert {
    condition     = output.protected_resource_address == "local_file.critical_config"
    error_message = "必须暴露受保护资源地址，方便后续执行 state rm。"
  }

  assert {
    condition     = strcontains(output.critical_config_path, "critical-config.txt")
    error_message = "必须创建 critical-config.txt 作为受保护文件。"
  }
}
