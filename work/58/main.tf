terraform {
  required_version = ">= 1.5.0"
}

locals {
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


