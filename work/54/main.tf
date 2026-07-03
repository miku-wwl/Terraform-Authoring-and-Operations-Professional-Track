terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：将 prod 环境的 replicas 从 1 改为 3。
  # 提示：测试预期 environments.prod.replicas 为 3。
  environments = { dev = { replicas = 1, region = "local" }, prod = { replicas = 1, region = "local" } }
}

resource "terraform_data" "lesson" {
  input = { topic = "读取嵌套值" }
}

output "prod_replicas" {
  value = local.environments.prod.replicas
}

output "environment_count" {
  value = length(local.environments)
}


