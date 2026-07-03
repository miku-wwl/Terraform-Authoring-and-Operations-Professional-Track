terraform {
  required_version = ">= 1.5.0"
}

locals {
  mock         = jsondecode(file("${path.module}/data/mock.json"))
  # TODO 1：将 for 过滤条件从 "frontend" 改为 "backend"，筛选 backend tier 的应用。
  # 提示：mock.json 中 api 和 worker 的 tier 是 "backend"，共 2 个。
  backend_apps = [for app in local.mock.apps : app.name if app.tier == "frontend"]
}

output "backend_apps" {
  value = local.backend_apps
}

output "backend_count" {
  value = length(local.backend_apps)
}
