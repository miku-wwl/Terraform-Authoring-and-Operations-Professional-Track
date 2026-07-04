terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define a service object with mixed attribute types.
  # Hint: include these attributes:
  # name = "payments", port = 8080, enabled = true,
  # tags = { owner = "platform", env = "dev" },
  # zones = ["az-a", "az-b"]
  service = {}

  # TODO 2: Read a string attribute from the object.
  # Hint: use local.service.name.
  service_name = "TODO-service-name"

  # TODO 3: Read a number attribute from the object.
  # Hint: use local.service.port.
  service_port = 0

  # TODO 4: Read a boolean attribute from the object.
  # Hint: use local.service.enabled.
  service_enabled = false

  # TODO 5: Read a nested map/object attribute.
  # Hint: use local.service.tags.owner.
  service_owner = "TODO-owner"

  # TODO 6: Read the first element from the object's zones list.
  # Hint: use local.service.zones[0].
  primary_zone = "TODO-zone"

  # TODO 7: Build a derived value from object attributes.
  # Hint: use "${local.service.name}:${local.service.port}".
  service_endpoint = "TODO-endpoint"
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
