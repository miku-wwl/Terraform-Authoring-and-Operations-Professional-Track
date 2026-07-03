terraform {
  required_version = ">= 1.5.0"
}

locals {
  raw_names    = ["api", "worker", "api"]
  # TODO 1：用 toset() 将 raw_names 转为 set，使 unique_count 为 2。
  # 提示：toset 会自动去重，去除重复的 "api"。
  unique_names = local.raw_names
}

resource "terraform_data" "lesson" {
  input = { topic = "set 数据类型" }
}

output "unique_names" {
  value = local.unique_names
}

output "unique_count" {
  value = length(local.unique_names)
}


