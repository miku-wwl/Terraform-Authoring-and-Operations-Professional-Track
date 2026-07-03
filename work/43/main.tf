terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：补全第 4 条 Vault 治理原则（共需 4 条）。
  # 提示：Terraform 从 Vault 读取 secret 后，secret 可能进入 state 文件。
  vault_operating_model = [
    "使用短期 token 或受控身份访问 Vault",
    "把 secret 写入 Vault，而不是写入 Terraform 代码仓库",
    "限制 Terraform 读取 secret 的路径和权限",

  ]
}

resource "terraform_data" "vault_readiness" {
  input = {
    mode       = "local-dev"
    # TODO 2：补全 secret engine 名称。
    # 提示：Vault 的 KV 引擎常用 kv-v2。
    engine     = "TODO-kv-engine"
    namespace  = "training"
    principles = local.vault_operating_model
  }
}

output "vault_readiness" {
  value = terraform_data.vault_readiness.output
}
