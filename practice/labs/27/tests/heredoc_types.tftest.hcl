run "heredoc_types_show_whitespace_difference" {
  command = plan

  assert {
    condition     = startswith(output.basic_heredoc, "    line-one")
    error_message = "基础 heredoc 必须保留 line-one 前面的空白。"
  }

  assert {
    condition     = startswith(output.indented_heredoc, "line-one")
    error_message = "indented heredoc 必须移除共同前导空白。"
  }
}
