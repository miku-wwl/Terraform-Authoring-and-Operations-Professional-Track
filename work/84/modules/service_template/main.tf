locals {
  # TODO 5: Merge common tags from the caller with standard module tags.
  # Hint: merge(var.extra_tags, {
  #   service     = var.service_name
  #   team        = var.team_name
  #   environment = var.environment
  #   owner       = var.owner
  # })
  standard_tags = {}

  # TODO 6: Convert ports into labels like "payments-api:8080".
  # Hint: [for port in var.ports : "${var.service_name}:${port}"]
  port_labels = []

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
