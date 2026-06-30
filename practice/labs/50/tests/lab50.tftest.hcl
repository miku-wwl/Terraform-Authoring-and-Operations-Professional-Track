run "lab_50_contract" {
  command = apply

  assert {
    condition     = output.values[0] == "ap-southeast-2"
    error_message = "list 数据类型 的关键断言必须通过。"
  }
}

