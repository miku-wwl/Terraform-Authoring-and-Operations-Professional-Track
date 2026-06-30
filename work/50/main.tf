terraform {
  required_version = ">= 1.5.0"
}

locals {
  values = ["TODO-region", "ap-southeast-1", "us-east-1"]
}

resource "terraform_data" "lesson" {
  input = { topic = "list 数据类型" }
}

output "values" {
  value = local.values
}

output "value_count" {
  value = length(local.values)
}


