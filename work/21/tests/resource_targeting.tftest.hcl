run "target_commands_are_explicit" {
  command = plan

  assert {
    condition     = contains(output.target_commands, "terraform plan -target=local_file.release_note")
    error_message = "必须记录 targeted plan 的资源地址。"
  }

  assert {
    condition     = output.resource_count == 2
    error_message = "实验必须包含多个资源以体现 targeting 的意义。"
  }
}
