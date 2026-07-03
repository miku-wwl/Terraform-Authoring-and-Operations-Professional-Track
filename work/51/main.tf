terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：将 map 中 owner 的值从 "TODO-owner" 改为 "platform"。
  # 提示：测试预期 tags.owner 为 "platform"。
  tags = { owner = "TODO-owner", env = "dev", cost_center = "cc-1001" }
}

resource "terraform_data" "lesson" {
  input = { topic = "map 数据类型" }
}

output "tags" {
  value = local.tags
}

output "tag_count" {
  value = length(local.tags)
}


