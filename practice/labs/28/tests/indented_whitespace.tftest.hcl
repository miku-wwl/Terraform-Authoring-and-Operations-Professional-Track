run "indented_heredoc_removes_common_whitespace" {
  command = plan

  assert {
    condition     = output.first_line == "app:"
    error_message = "第一行共同前导空白应被移除。"
  }

  assert {
    condition     = output.second_line == "  name: payments"
    error_message = "第二行应保留相对缩进。"
  }

  assert {
    condition     = output.line_count == 3
    error_message = "输出应包含三行 YAML 内容。"
  }
}
