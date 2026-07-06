locals {
  standard_tags = merge(var.extra_tags, {
    service     = var.service_name
    team        = var.team_name
    environment = var.environment
    owner       = var.owner
  })

  port_labels = [for port in var.ports : "${var.service_name}:${port}"]

  service_record = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    owner        = var.owner
    enabled      = var.enabled
    ports        = var.ports
    tags         = local.standard_tags
    port_labels  = local.port_labels
  }
}

resource "terraform_data" "service" {
  input = local.service_record
}
