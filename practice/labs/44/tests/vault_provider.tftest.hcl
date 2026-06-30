run "vault_provider_reads_written_secret" {
  command = apply

  variables {
    vault_addr  = "http://vault:8200"
    vault_token = "root"
  }

  assert {
    condition     = output.vault_secret_username == "app"
    error_message = "Terraform 必须能从 Vault 读取写入的 username。"
  }

  assert {
    condition     = output.vault_secret_has_password == true
    error_message = "Vault secret 必须包含 password 字段。"
  }
}
