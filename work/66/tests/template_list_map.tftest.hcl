run "template_renders_map" {
  command = apply

  assert {
    condition     = strcontains(output.rendered, "api: 8080")
    error_message = "模板必须渲染 map 中的 api 端口。"
  }
}
