run "lab_53_contract" {
  command = apply

  assert {
    condition     = output.service_count == 2
    error_message = "嵌套类型 的关键断言必须通过。"
  }
}

