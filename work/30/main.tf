terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  # TODO 1：用 jsondecode(file(...)) 从 data/catalog.json 读取服务目录。
  # 提示：jsondecode 把 JSON 转为 Terraform 对象，然后用 .services 访问数组。
  catalog          = "TODO：用 jsondecode + file 读取 catalog.json"

  # TODO 2：用 for 表达式筛选 tier == "backend" 的服务，并提取 name 和 ports。
  # 提示：[for service in local.catalog.services : service if service.tier == "backend"]
  # TODO 3：通过索引 [0] 取出第一个 backend 服务，再通过 .ports 取出端口列表。
  # 提示：list 用 [index] 索引，object 用 .field 访问。
  backend_services = "TODO：用 for 筛选 backend 服务"
  first_backend    = "TODO：取 backend_services[0]"
  backend_ports    = "TODO：取 first_backend.ports"
}

resource "local_file" "backend_summary" {
  filename = "${path.module}/output/backend-summary.txt"
  content  = "服务：${local.first_backend.name}\n端口：${join(",", [for port in local.backend_ports : tostring(port)])}\n"
}

output "backend_service_name" {
  value = local.first_backend.name
}

output "first_backend_port" {
  value = local.backend_ports[0]
}

output "backend_port_count" {
  value = length(local.backend_ports)
}
