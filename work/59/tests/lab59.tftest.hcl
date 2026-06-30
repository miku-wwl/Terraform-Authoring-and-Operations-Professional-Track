run "lab_59_contract" {
  command = apply

  assert {
    condition     = contains(output.upper_users, "ALICE")
    error_message = "for 表达式基础 的关键断言必须通过。"
  }
}

