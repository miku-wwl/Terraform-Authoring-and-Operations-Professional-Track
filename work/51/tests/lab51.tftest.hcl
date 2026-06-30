run "lab_51_contract" {
  command = apply

  assert {
    condition     = output.tags.owner == "platform"
    error_message = "map 数据类型 的关键断言必须通过。"
  }
}

