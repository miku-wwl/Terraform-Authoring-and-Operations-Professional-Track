run "heredoc_contains_script_lines" {
  command = plan

  assert {
    condition     = strcontains(output.script_preview, "#!/bin/sh")
    error_message = "heredoc 必须包含脚本头。"
  }

  assert {
    condition     = strcontains(output.script_preview, "完成部署")
    error_message = "heredoc 必须保留多行脚本内容。"
  }
}
