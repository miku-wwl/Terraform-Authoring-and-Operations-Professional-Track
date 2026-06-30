run "lock_file_contract" {
  command = apply

  assert {
    condition     = output.lock_file_name == ".terraform.lock.hcl"
    error_message = "必须识别依赖锁文件名称。"
  }
}
