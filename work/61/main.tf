terraform {
  required_version = ">= 1.5.0"
}

locals {
  services         = { api = true, worker = false, billing = true }
  # TODO 1：将 for 表达式中的 if false 改为 if enabled，使过滤条件由 map 的 value 决定。
  # 提示：map 中 api=true、billing=true，用 if enabled 筛选出值为 true 的 key。
  enabled_services = [for name, enabled in local.services : name if false]
}

resource "terraform_data" "lesson" {
  input = { topic = "for 表达式进阶" }
}

output "enabled_services" {
  value = local.enabled_services
}

output "enabled_count" {
  value = length(local.enabled_services)
}


