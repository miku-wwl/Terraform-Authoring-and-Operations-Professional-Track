terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：将 environment 从 "dev" 改为 "prod"，使条件表达式返回 "large"。
  # 提示：条件表达式 prod ? "large" : "small"，当前 "dev" 会返回 "small"。
  environment   = "dev"
  instance_size = local.environment == "prod" ? "large" : "small"
}

resource "terraform_data" "lesson" {
  input = { topic = "条件表达式" }
}

output "environment" {
  value = local.environment
}

output "instance_size" {
  value = local.instance_size
}


