run "lab_52_contract" {
  command = apply

  assert {
    condition     = output.service.port == 8080
    error_message = "object 数据类型 的关键断言必须通过。"
  }
}

