terraform {
  required_version = ">= 1.5.0"
}

locals {
  csv_rules = csvdecode(file("${path.module}/data/sg-01.csv"))

  inbound_rules = [for rule in local.csv_rules : rule if rule.direction == "in"]

  outbound_rules = [for rule in local.csv_rules : rule if rule.direction == "out"]

  inbound_rules_by_name = { for rule in local.inbound_rules : rule.name => rule }

  outbound_rules_by_name = { for rule in local.outbound_rules : rule.name => rule }

  inbound_rule_names  = [for rule in local.inbound_rules : rule.name]
  outbound_rule_names = [for rule in local.outbound_rules : rule.name]
}

resource "terraform_data" "security_group" {
  input = {
    name    = "use-case-01-sg"
    purpose = "mock security group for CSV driven rules"
  }
}

resource "terraform_data" "ingress_rule" {
  for_each = local.inbound_rules_by_name

  input = {
    name                = each.value.name
    direction           = each.value.direction
    security_group_name = terraform_data.security_group.input.name
    cidr_ipv4           = each.value.cidr_block
    from_port           = tonumber(each.value.from_port)
    to_port             = tonumber(each.value.to_port)
    ip_protocol         = each.value.protocol
    description         = each.value.description
  }
}

resource "terraform_data" "egress_rule" {
  for_each = local.outbound_rules_by_name

  input = {
    name                = each.value.name
    direction           = each.value.direction
    security_group_name = terraform_data.security_group.input.name
    cidr_ipv4           = each.value.cidr_block
    from_port           = tonumber(each.value.from_port)
    to_port             = tonumber(each.value.to_port)
    ip_protocol         = each.value.protocol
    description         = each.value.description
  }
}

output "csv_rules" {
  description = "Rules decoded from data/sg-01.csv. CSV values are strings before conversion."
  value       = local.csv_rules
}

output "inbound_rules" {
  description = "Rules selected where direction is in."
  value       = local.inbound_rules
}

output "outbound_rules" {
  description = "Rules selected where direction is out."
  value       = local.outbound_rules
}

output "inbound_rule_names" {
  description = "Inbound rule names selected from CSV."
  value       = local.inbound_rule_names
}

output "outbound_rule_names" {
  description = "Outbound rule names selected from CSV."
  value       = local.outbound_rule_names
}

output "inbound_rules_by_name" {
  description = "Inbound rules keyed by unique rule name for for_each."
  value       = local.inbound_rules_by_name
}

output "outbound_rules_by_name" {
  description = "Outbound rules keyed by unique rule name for for_each."
  value       = local.outbound_rules_by_name
}

output "ingress_rule_models" {
  description = "Mock ingress rule resources created from inbound rules."
  value       = { for name, rule in terraform_data.ingress_rule : name => rule.input }
}

output "egress_rule_models" {
  description = "Mock egress rule resources created from outbound rules."
  value       = { for name, rule in terraform_data.egress_rule : name => rule.input }
}
