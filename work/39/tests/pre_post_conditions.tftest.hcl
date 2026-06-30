run "pre_and_post_conditions_pass" {
  command = apply

  assert {
    condition     = output.compute_size == "small"
    error_message = "默认规格必须通过 precondition 和 postcondition。"
  }
}
