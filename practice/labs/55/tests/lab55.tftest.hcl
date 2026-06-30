run "lab_55_contract" {
  command = apply

  assert {
    condition     = output.user_count == 3
    error_message = "count 的索引挑战 的关键断言必须通过。"
  }
}

