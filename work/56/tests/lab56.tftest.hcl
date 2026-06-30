run "lab_56_contract" {
  command = apply

  assert {
    condition     = output.unique_count == 2
    error_message = "set 数据类型 的关键断言必须通过。"
  }
}

