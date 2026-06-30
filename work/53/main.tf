terraform {
  required_version = ">= 1.5.0"
}

locals {
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


