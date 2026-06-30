terraform {
  required_version = ">= 1.5.0"
}

locals {
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


