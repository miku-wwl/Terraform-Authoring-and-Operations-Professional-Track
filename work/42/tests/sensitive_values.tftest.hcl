run "sensitive_token_is_configured" {
  command = apply

  variables {
    api_token = "local-token-123456"
  }

  assert {
    condition     = output.token_is_configured == true
    error_message = "敏感 token 必须被设置。"
  }

  assert {
    condition     = strcontains(output.state_risk_message, "tfstate")
    error_message = "实验必须提醒 sensitive 不等于 state 加密。"
  }
}
