run "csv_creates_multiple_files" {
  command = apply

  assert {
    condition     = length(output.generated_files) == 2
    error_message = "必须基于 CSV 创建两个文件。"
  }
}
