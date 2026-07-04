terraform {
  required_version = ">= 1.5.0"
}

locals {
  tags = { owner = "platform", env = "dev", cost_center = "cc-1001" }

  owner_tag = local.tags["owner"]

  tag_count = length(local.tags)

  tag_keys = keys(local.tags)

  service_name = lookup(local.tags, "service", "checkout")

  tag_labels = [for key, value in local.tags : "${key}=${value}"]
}

resource "terraform_data" "lesson" {
  input = {
    topic = "map 数据类型"
    tags  = local.tags
  }
}

output "tags" {
  description = "完整 tag map。"
  value       = local.tags
}

output "owner_tag" {
  description = "通过 map key 读取出的 owner tag。"
  value       = local.owner_tag
}

output "tag_count" {
  description = "通过 length() 计算出的 map 键值对数量。"
  value       = local.tag_count
}

output "tag_keys" {
  description = "通过 keys() 取得的 map key list。"
  value       = local.tag_keys
}

output "service_name" {
  description = "通过 lookup() 读取的可选 service 名称。"
  value       = local.service_name
}

output "tag_labels" {
  description = "通过 for 表达式生成的 key=value 标签。"
  value       = local.tag_labels
}
