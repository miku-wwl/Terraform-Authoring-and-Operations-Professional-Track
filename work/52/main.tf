terraform {
  required_version = ">= 1.5.0"
}

locals {
  service = {
    name    = "payments",
    port    = 8080,
    enabled = true,
    tags    = { owner = "platform", env = "dev" },
    zones   = ["az-a", "az-b"]
  }

  service_name = local.service.name

  service_port = local.service.port

  service_enabled = local.service.enabled

  service_owner = local.service.tags.owner

  primary_zone = local.service.zones[0]

  service_endpoint = "${local.service.name}:${local.service.port}"
}

resource "terraform_data" "lesson" {
  input = {
    topic   = "object 数据类型"
    service = local.service
  }
}

output "service" {
  description = "完整 service object。"
  value       = local.service
}

output "service_name" {
  description = "通过 object 属性读取的服务名。"
  value       = local.service_name
}

output "service_port" {
  description = "通过 object 属性读取的端口。"
  value       = local.service_port
}

output "service_enabled" {
  description = "通过 object 属性读取的启用状态。"
  value       = local.service_enabled
}

output "service_owner" {
  description = "通过嵌套属性读取的 owner。"
  value       = local.service_owner
}

output "primary_zone" {
  description = "通过 object 内 list 属性读取的第一个 zone。"
  value       = local.primary_zone
}

output "service_endpoint" {
  description = "通过 object 属性拼接出的 endpoint。"
  value       = local.service_endpoint
}
