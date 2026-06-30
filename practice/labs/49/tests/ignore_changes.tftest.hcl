run "ignore_changes_is_configured" {
  command = apply

  assert {
    condition     = output.ignored_attribute == "content"
    error_message = "实验必须忽略 content 属性漂移。"
  }

  assert {
    condition     = strcontains(output.managed_file, "managed-note.txt")
    error_message = "必须生成受管理文件。"
  }
}
