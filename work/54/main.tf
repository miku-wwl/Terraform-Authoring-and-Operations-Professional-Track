terraform {
  required_version = ">= 1.5.0"
}

locals {
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


