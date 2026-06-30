run "create_before_destroy_strategy_is_set" {
  command = apply

  assert {
    condition     = output.replacement_strategy == "create_before_destroy"
    error_message = "必须记录替换策略为 create_before_destroy。"
  }
}
