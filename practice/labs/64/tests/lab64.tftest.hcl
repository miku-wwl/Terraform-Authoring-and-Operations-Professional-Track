run "lab_64_contract" {
  command = apply

  assert {
    condition     = output.unique_count == 3
    error_message = "flatten 与 distinct 的关键断言必须通过。"
  }
}

