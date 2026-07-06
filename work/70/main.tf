terraform {
  required_version = ">= 1.5.0"
}

locals {
  csv_data = csvdecode(file("${path.module}/data/sg_03.csv"))

  processed_rules = [
    for rule in local.csv_data : {
      name       = rule.name
      direction  = rule.direction
      protocol   = rule.protocol
      cidr_block = rule.cidr_block

      from_port = can(regex("-", rule.port)) ? tonumber(split("-", rule.port)[0]) : tonumber(rule.port)
      to_port   = can(regex("-", rule.port)) ? tonumber(split("-", rule.port)[1]) : tonumber(rule.port)
    }
  ]

  ingress_rules_by_key = { for index, rule in local.processed_rules : "${rule.name}-${index}" => rule }
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
