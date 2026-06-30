run "vault_operating_model_is_documented" {
  command = apply

  assert {
    condition     = output.vault_readiness.engine == "kv-v2"
    error_message = "实验必须说明使用 kv-v2 secret engine。"
  }

  assert {
    condition     = length(output.vault_readiness.principles) == 4
    error_message = "必须记录 Vault 治理原则。"
  }
}
