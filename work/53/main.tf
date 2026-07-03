terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：在 services 列表中添加第二个服务对象，使 service_count 为 2。
  # 提示：添加 { name = "worker", ports = [9000] } 作为第二个元素。
  services = [{ name = "api", ports = [8080, 9090] }]
}

resource "terraform_data" "lesson" {
  input = { topic = "嵌套类型" }
}

output "services" {
  value = local.services
}

output "service_count" {
  value = length(local.services)
}


