terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.6"
    }
  }
}

variable "vault_addr" {
  type        = string
  description = "Vault 地址。"
}

variable "vault_token" {
  type        = string
  description = "Vault token。"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "写入 Vault 的模拟数据库密码。"
  sensitive   = true
  default     = "local-db-password"
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

resource "vault_mount" "secret" {
  path = "training"
  type = "kv-v2"
}

resource "vault_kv_secret_v2" "db_creds" {
  mount = vault_mount.secret.path
  name  = "db_creds"

  data_json = jsonencode({
    username = "app"
    password = var.db_password
  })
}

data "vault_kv_secret_v2" "db_creds" {
  mount      = vault_mount.secret.path
  name       = vault_kv_secret_v2.db_creds.name
  depends_on = [vault_kv_secret_v2.db_creds]
}

output "vault_secret_username" {
  value = nonsensitive(data.vault_kv_secret_v2.db_creds.data.username)
}

output "vault_secret_has_password" {
  value = nonsensitive(contains(keys(data.vault_kv_secret_v2.db_creds.data), "password"))
}
