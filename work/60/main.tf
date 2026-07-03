terraform {
  required_version = ">= 1.5.0"
}

locals {
  services         = csvdecode(file("${path.module}/data/services.csv"))
  # TODO 1：将 for 过滤条件中的 "TODO" 改为 "true"，筛选出 enabled 服务。
  # 提示：CSV 中 enabled 列的值为 "true" 或 "false"，需筛选 enabled == "true"。
  enabled_services = [for service in local.services : service.name if service.enabled == "TODO"]
}

output "service_count" {
  value = length(local.services)
}

output "enabled_services" {
  value = local.enabled_services
}
