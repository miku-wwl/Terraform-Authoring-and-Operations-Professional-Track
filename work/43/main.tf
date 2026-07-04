terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：声明本实验使用的 Vault KV secret engine。
  # 提示：Vault dev server 默认会挂载 secret/，命令行用 vault kv put/get 访问；这里记录 engine 类型为 kv-v2。
  vault_secret_engine = "TODO-kv-engine"

  # TODO 2：声明 smoke test 要写入和读取的 secret 路径。
  # 提示：README 中的 Vault smoke test 目标是 secret/db_creds。
  db_creds_secret_path = "TODO-secret-path"

  # TODO 3：本实验不让 Terraform 读取 secret 原文，避免把 secret 值带进 state。
  # 提示：把这里改成 false；secret 写入/读取由 scripts/vault-dev-smoke.sh 通过 Vault CLI 完成。
  terraform_reads_secret_value = true

  state_risk_note = "Terraform state and saved plan files must be protected because provider-read secrets can be stored in tfstate."
}

resource "terraform_data" "vault_readiness" {
  input = {
    mode                         = "local-dev-server"
    engine                       = local.vault_secret_engine
    secret_path                  = local.db_creds_secret_path
    terraform_reads_secret_value = local.terraform_reads_secret_value
    state_risk_note              = local.state_risk_note
  }
}

output "vault_readiness" {
  value = terraform_data.vault_readiness.output
}
