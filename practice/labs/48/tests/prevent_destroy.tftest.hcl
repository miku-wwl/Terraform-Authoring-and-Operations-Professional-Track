run "prevent_destroy_is_documented" {
  command = plan

  assert {
    condition     = output.protected_resource == "local_file.critical_config"
    error_message = "必须明确受保护资源地址。"
  }

  assert {
    condition     = strcontains(output.cleanup_command, "terraform state rm")
    error_message = "必须提供实验清理命令。"
  }
}
