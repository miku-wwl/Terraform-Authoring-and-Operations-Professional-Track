terraform {
  required_version = ">= 1.5.0"
}

locals {
  vault_operating_model = [
    "使用短期 token 或受控身份访问 Vault",
    "把 secret 写入 Vault，而不是写入 Terraform 代码仓库",
    "限制 Terraform 读取 secret 的路径和权限",

  ]
}

resource "terraform_data" "vault_readiness" {
  input = {
    mode       = "local-dev"
    engine     = "TODO-kv-engine"
    namespace  = "training"
    principles = local.vault_operating_model
  }
}

output "vault_readiness" {
  value = terraform_data.vault_readiness.output
}
