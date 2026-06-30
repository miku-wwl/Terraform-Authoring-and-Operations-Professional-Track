run "no_color_is_used_for_ci_logs" {
  command = plan

  assert {
    condition     = output.plan_capture_commands.clean_output == "terraform plan -no-color > no-color.plan"
    error_message = "保存给工具解析的 plan 文本必须使用 -no-color。"
  }

  assert {
    condition     = output.plan_capture_commands.ci_plan == "terraform plan -input=false -no-color -out=tfplan"
    error_message = "CI plan 命令必须同时禁用输入、禁用颜色并保存 plan。"
  }
}

