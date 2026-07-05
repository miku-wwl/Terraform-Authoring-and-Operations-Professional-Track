terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the CSV security group rule file.
  # Hint: use csvdecode(file("${path.module}/data/sg_03.csv")).
  csv_data = []

  # TODO 2: Build processed ingress rules from the decoded CSV rows.
  # Hint: use a for expression over local.csv_data.
  # TODO 3: Keep name, direction, protocol, and cidr_block from each CSV row.
  # TODO 4: Detect ranged ports with can(regex("-", rule.port)).
  # TODO 5: Use split("-", rule.port) and tonumber() to produce from_port and to_port.
  processed_rules = []

  # TODO 6: Build a map that can be used by for_each.
  # Hint: CSV rule names are not unique, so include index in the key.
  ingress_rules_by_key = {}
}

resource "terraform_data" "ingress_rule" {
  for_each = local.ingress_rules_by_key

  input = {
    name       = each.value.name
    direction  = each.value.direction
    protocol   = each.value.protocol
    cidr_block = each.value.cidr_block
    from_port  = each.value.from_port
    to_port    = each.value.to_port
  }
}

output "csv_data" {
  description = "Security group rule rows decoded from data/sg_03.csv."
  value       = local.csv_data
}

output "processed_rules" {
  description = "CSV rules transformed into explicit from_port and to_port values."
  value       = local.processed_rules
}

output "ingress_rules_by_key" {
  description = "Processed rules keyed uniquely for for_each."
  value       = local.ingress_rules_by_key
}

output "ingress_rule_keys" {
  description = "Unique keys used by for_each."
  value       = keys(local.ingress_rules_by_key)
}

output "ingress_rule_inputs" {
  description = "Inputs passed to the terraform_data resource instances."
  value = {
    for key, rule in terraform_data.ingress_rule : key => rule.input
  }
}
