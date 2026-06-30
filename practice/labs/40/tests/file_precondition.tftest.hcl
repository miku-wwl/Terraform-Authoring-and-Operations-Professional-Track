run "file_precondition_passes" {
  command = apply

  assert {
    condition     = output.db_file_is_non_empty == true
    error_message = "数据库凭据文件内容不能为空。"
  }

  assert {
    condition     = strcontains(output.app_config_file, "app.txt")
    error_message = "必须生成应用配置文件。"
  }
}
