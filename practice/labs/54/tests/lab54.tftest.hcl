run "lab_54_contract" {
  command = apply

  assert {
    condition     = output.prod_replicas == 3
    error_message = "读取嵌套值 的关键断言必须通过。"
  }
}

