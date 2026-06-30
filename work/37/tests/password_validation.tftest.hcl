run "password_policy_passes" {
  command = apply

  assert {
    condition     = output.password_policy.min_length == 12
    error_message = "密码策略必须要求至少 12 位。"
  }

  assert {
    condition     = output.password_policy.accepted == true
    error_message = "默认密码必须通过长度验证。"
  }
}
