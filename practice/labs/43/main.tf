terraform {
  required_version = ">= 1.5.0"
}

locals {
  vault_operating_model = [
    "使用短期 token 或受控身份访问 Vault",
    "把 secret 写入 Vault，而不是写入 Terraform 代码仓库",
    "限制 Terraform 读取 secret 的路径和权限",
    "保护 Terraform state，因为读取到的 secret 可能进入 state",
  ]
}

resource "terraform_data" "vault_readiness" {
  input = {
    mode       = "local-dev"
    engine     = "kv-v2"
    namespace  = "training"
    principles = local.vault_operating_model
  }
}

output "vault_readiness" {
  value = terraform_data.vault_readiness.output
}
