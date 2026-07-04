terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define a map of common resource tags.
  # Hint: use key = value pairs inside braces:
  # owner = "platform", env = "dev", cost_center = "cc-1001"
  tags = { owner = "platform", env = "dev", cost_center = "cc-1001" }

  # TODO 2: Read one map value by key.
  # Hint: use local.tags["owner"].
  owner_tag = local.tags["owner"]

  # TODO 3: Count how many key/value pairs are in the map.
  # Hint: use length(local.tags).
  tag_count = length(local.tags)

  # TODO 4: Get the sorted list of map keys.
  # Hint: use keys(local.tags).
  tag_keys = keys(local.tags)

  # TODO 5: Read an optional key with a fallback value.
  # Hint: use lookup(local.tags, "service", "checkout").
  service_name = lookup(local.tags, "service", "checkout")

  # TODO 6: Convert the map into "key=value" labels.
  # Hint: use [for key, value in local.tags : "${key}=${value}"].
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
