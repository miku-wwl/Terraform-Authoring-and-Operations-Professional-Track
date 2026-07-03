terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：将 list 第一个元素从 "TODO-region" 改为正确的区域名称。
  # 提示：测试预期 values[0] 为 "ap-southeast-2"。
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


