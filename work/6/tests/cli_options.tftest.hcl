run "cli_help_and_flags_are_documented" {
  command = plan

  assert {
    condition     = output.command_catalog.plan_help == "terraform plan -help"
    error_message = "必须记录 terraform plan 的 help 查询方式。"
  }

  assert {
    condition     = output.automation_flags.input_false == "-input=false"
    error_message = "必须记录自动化环境中禁用交互输入的参数。"
  }

  assert {
    condition     = output.automation_flags.saved_plan == "-out=tfplan"
    error_message = "必须记录保存 plan 文件的参数。"
  }
}

