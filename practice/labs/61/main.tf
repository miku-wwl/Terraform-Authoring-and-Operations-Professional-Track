terraform {
  required_version = ">= 1.5.0"
}

locals {
  services         = { api = true, worker = false, billing = true }
  enabled_services = [for name, enabled in local.services : name if enabled]
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


