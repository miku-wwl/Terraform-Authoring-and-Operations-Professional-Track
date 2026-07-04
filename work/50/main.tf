terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define a list of three region strings.
  # Hint: use square brackets and keep this order:
  # "ap-southeast-2", "ap-southeast-1", "us-east-1"
  regions = []

  # TODO 2: Read the first list element by index.
  # Hint: Terraform list indexes start at 0, so use local.regions[0].
  primary_region = "TODO-primary-region"

  # TODO 3: Count how many elements are in the list.
  # Hint: use length(local.regions).
  region_count = 0

  # TODO 4: Build one label per region with a for expression.
  # Hint: use [for index, region in local.regions : "${index}:${region}"].
  indexed_region_labels = []
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
