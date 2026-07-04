terraform {
  required_version = ">= 1.5.0"
}

locals {
  regions = ["ap-southeast-2", "ap-southeast-1", "us-east-1"]

  primary_region = local.regions[0]

  region_count = length(local.regions)

  indexed_region_labels = [for index, region in local.regions : "${index}:${region}"]
}

resource "terraform_data" "lesson" {
  input = {
    topic   = "list 数据类型"
    regions = local.regions
  }
}

output "regions" {
  description = "完整 region list。"
  value       = local.regions
}

output "primary_region" {
  description = "通过 list index 读取的第一个 region。"
  value       = local.primary_region
}

output "region_count" {
  description = "通过 length() 计算出的 list 元素数量。"
  value       = local.region_count
}

output "indexed_region_labels" {
  description = "通过 for 表达式生成的 index:region 标签。"
  value       = local.indexed_region_labels
}
