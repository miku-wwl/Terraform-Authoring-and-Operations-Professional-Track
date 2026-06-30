run "lab_58_contract" {
  command = apply

  assert {
    condition     = output.instance_size == "large"
    error_message = "条件表达式 的关键断言必须通过。"
  }
}

