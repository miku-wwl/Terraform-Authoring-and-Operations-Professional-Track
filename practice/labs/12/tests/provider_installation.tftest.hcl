run "provider_installation_policy_is_clear" {
  command = plan

  assert {
    condition     = contains(output.provider_installation_policy, "air-gapped 环境不要配置 direct 回退")
    error_message = "必须说明离线环境不应依赖 direct 回退。"
  }
}

