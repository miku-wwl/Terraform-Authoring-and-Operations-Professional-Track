run "lab_63_contract" {
  command = apply

  assert {
    condition     = output.pair_count == 4
    error_message = "嵌套 for 表达式 的关键断言必须通过。"
  }
}

