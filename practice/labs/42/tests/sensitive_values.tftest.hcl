run "sensitive_token_is_configured" {
  command = apply

  assert {
    condition     = output.token_is_configured == true
    error_message = "敏感 token 必须被设置。"
  }
}
