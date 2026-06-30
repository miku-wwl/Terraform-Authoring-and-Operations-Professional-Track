run "lab_57_contract" {
  command = apply

  assert {
    condition     = output.service_count == 2
    error_message = "for_each 基础 的关键断言必须通过。"
  }
}

