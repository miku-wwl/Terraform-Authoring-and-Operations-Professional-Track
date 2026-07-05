terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the CSV rule file.
  # Hint: use csvdecode(file("${path.module}/data/sg-71.csv")).
  raw_rules = []

  # TODO 2: Read and decode the JSON file whose keys match cidr_alias values.
  # Hint: use jsondecode(file("${path.module}/data/app.json")).
  app_cidr_by_alias = {}

  # TODO 3: Build ingress rule objects by looking up CIDR from app_cidr_by_alias.
  # Hint: use { for rule in local.raw_rules : rule.name => { ... } }.
  # Hint: cidr_ipv4 = local.app_cidr_by_alias[rule.cidr_alias].
  # Hint: from_port and to_port should be tonumber(rule.port).
  direct_ingress_rules = {}

  # TODO 4: Read and decode the second JSON file whose keys do not match cidr_alias values.
  # Hint: use jsondecode(file("${path.module}/data/app-v2.json")).
  app_cidr_by_mapped_name = {}

  # TODO 5: Map CSV aliases to the keys used by data/app-v2.json.
  # Hint: app-1 => app, app-2 => database, ops => observability.
  name_mapping = {}

  # TODO 6: Build ingress rules by first mapping the CSV alias, then looking up CIDR.
  # Hint: cidr_ipv4 = local.app_cidr_by_mapped_name[local.name_mapping[rule.cidr_alias]].
  mapped_ingress_rules = {}

  # TODO 7: Build sorted labels like "https_app:10.70.0.0/16:443" from mapped_ingress_rules.
  # Hint: use sort([for name, rule in local.mapped_ingress_rules : "${name}:${rule.cidr_ipv4}:${rule.from_port}"]).
  rule_labels = []
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
