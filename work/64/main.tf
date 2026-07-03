terraform {
  required_version = ">= 1.5.0"
}

locals {
  nested      = [["api", "worker"], ["api", "billing"]]
  flat        = flatten(local.nested)
  # TODO 1：用 distinct() 对 flat 列表去重，使 unique_count 为 3。
  # 提示：flat 是 ["api", "worker", "api", "billing"]，distinct 后为 ["api", "worker", "billing"]。
  unique_flat = local.flat
}

resource "terraform_data" "lesson" {
  input = { topic = "flatten 与 distinct" }
}

output "flat" {
  value = local.flat
}

output "unique_flat" {
  value = local.unique_flat
}

output "unique_count" {
  value = length(local.unique_flat)
}


