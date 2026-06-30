run "tf_in_automation_is_documented" {
  command = plan

  assert {
    condition     = output.automation_environment.linux_macos == "export TF_IN_AUTOMATION=true"
    error_message = "必须记录 Linux/macOS 中设置 TF_IN_AUTOMATION 的方式。"
  }

  assert {
    condition     = output.automation_environment.powershell == "$env:TF_IN_AUTOMATION='true'"
    error_message = "必须记录 PowerShell 中设置 TF_IN_AUTOMATION 的方式。"
  }
}

