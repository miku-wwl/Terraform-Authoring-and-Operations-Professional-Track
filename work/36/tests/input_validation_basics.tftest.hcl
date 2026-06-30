run "valid_workspace_name_passes" {
  command = apply

  assert {
    condition     = output.workspace_name == "team-dev-01"
    error_message = "合法工作区名称必须通过验证。"
  }

  assert {
    condition     = strcontains(output.validation_purpose, "plan 阶段")
    error_message = "必须说明变量验证会把错误前移到 plan 阶段。"
  }
}
