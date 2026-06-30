run "escape_sequences_render_expected_text" {
  command = plan

  assert {
    condition     = strcontains(output.quoted_message, "\"Alice\"")
    error_message = "输出必须保留 Alice 两侧的双引号。"
  }

  assert {
    condition     = output.escaped_path == "C:\\terraform\\training\\lab25"
    error_message = "Windows 路径中的反斜杠必须正确转义。"
  }
}
