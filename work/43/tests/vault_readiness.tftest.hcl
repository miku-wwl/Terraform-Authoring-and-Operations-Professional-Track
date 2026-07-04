run "vault_integration_contract_is_documented" {
  command = apply

  assert {
    condition     = output.vault_readiness.engine == "kv-v2"
    error_message = "实验必须说明使用 kv-v2 secret engine。"
  }

  assert {
    condition     = output.vault_readiness.secret_path == "secret/db_creds"
    error_message = "Vault smoke test 必须围绕 secret/db_creds。"
  }

  assert {
    condition     = output.vault_readiness.terraform_reads_secret_value == false
    error_message = "本实验不应让 Terraform 读取 secret 原文，避免把 secret 带进 state。"
  }

  assert {
    condition     = strcontains(output.vault_readiness.state_risk_note, "tfstate")
    error_message = "必须明确提醒 Terraform state 可能保存 provider 读到的 secret。"
  }
}
