terraform {
  required_version = ">= 1.5.0"
}

locals {
  raw_rules = csvdecode(file("${path.module}/data/sg-71.csv"))

  app_cidr_by_alias = jsondecode(file("${path.module}/data/app.json"))

  direct_ingress_rules = {
    for rule in local.raw_rules : rule.name => {
      direction  = rule.direction
      protocol   = rule.protocol
      cidr_alias = rule.cidr_alias
      cidr_ipv4  = local.app_cidr_by_alias[rule.cidr_alias]
      from_port  = tonumber(rule.port)
      to_port    = tonumber(rule.port)
    }
  }

  app_cidr_by_mapped_name = jsondecode(file("${path.module}/data/app-v2.json"))

  name_mapping = {
    "app-1" = "app"
    "app-2" = "database"
    ops     = "observability"
  }

  mapped_ingress_rules = {
    for rule in local.raw_rules : rule.name => {
      direction  = rule.direction
      protocol   = rule.protocol
      cidr_alias = rule.cidr_alias
      cidr_ipv4  = local.app_cidr_by_mapped_name[local.name_mapping[rule.cidr_alias]]
      from_port  = tonumber(rule.port)
      to_port    = tonumber(rule.port)
    }
  }

  rule_labels = sort([for name, rule in local.mapped_ingress_rules : "${name}:${rule.cidr_ipv4}:${rule.from_port}"])
}

resource "terraform_data" "ingress_rule" {
  for_each = local.mapped_ingress_rules

  input = each.value
}

output "raw_rules" {
  description = "Rules decoded from data/sg-71.csv."
  value       = local.raw_rules
}

output "direct_ingress_rules" {
  description = "Ingress rules whose CIDR values are resolved from data/app.json."
  value       = local.direct_ingress_rules
}

output "mapped_ingress_rules" {
  description = "Ingress rules whose CIDR values are resolved from data/app-v2.json through name_mapping."
  value       = local.mapped_ingress_rules
}

output "rule_labels" {
  description = "Sorted rule_name:cidr_ipv4:port labels generated from mapped rules."
  value       = local.rule_labels
}

output "simulated_rule_names" {
  description = "Keys of terraform_data.ingress_rule resources created with for_each."
  value       = keys(terraform_data.ingress_rule)
}
