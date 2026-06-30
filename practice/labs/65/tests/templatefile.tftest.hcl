run "templatefile_renders_values" {
  command = apply

  assert {
    condition     = strcontains(output.rendered, "payments")
    error_message = "模板必须渲染服务名。"
  }
}
