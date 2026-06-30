run "lab_61_contract" {
  command = apply

  assert {
    condition     = contains(output.enabled_services, "api")
    error_message = "for 表达式进阶 的关键断言必须通过。"
  }
}

