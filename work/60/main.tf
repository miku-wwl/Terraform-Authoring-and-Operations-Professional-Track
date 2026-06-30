terraform {
  required_version = ">= 1.5.0"
}

locals {
  services         = csvdecode(file("${path.module}/data/services.csv"))
  enabled_services = [for service in local.services : service.name if service.enabled == "TODO"]
}

output "service_count" {
  value = length(local.services)
}

output "enabled_services" {
  value = local.enabled_services
}
