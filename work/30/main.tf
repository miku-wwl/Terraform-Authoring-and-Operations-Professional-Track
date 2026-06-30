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
  catalog          = jsondecode(file("${path.module}/data/catalog.json"))
  backend_services = [for service in local.catalog.services : service if service.tier == "frontend"]
  first_backend    = local.backend_services[0]
  backend_ports    = local.first_backend.ports
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
