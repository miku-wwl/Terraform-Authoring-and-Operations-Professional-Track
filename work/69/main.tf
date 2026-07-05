terraform {
  required_version = ">= 1.5.0"
}

locals {
  security_group_name = "use-case-02-sg"
  rule_file           = "${path.module}/data/sg-02.csv"

  # TODO 1: Read and decode the CSV rule file.
  # Hint: use csvdecode(file(local.rule_file)).
  rules = []

  # TODO 2: Keep only ingress rules.
  # Hint: use a for expression with if rule.direction == "ingress".
  ingress_rules = []

  # TODO 3: Keep only egress rules.
  # Hint: use a for expression with if rule.direction == "egress".
  egress_rules = []

  # TODO 4: Build a map of ingress rules keyed by list index.
  # Hint: use { for index, rule in local.ingress_rules : index => rule }.
  ingress_rules_by_index = {}

  # TODO 5: Build a map of egress rules keyed by list index.
  # Hint: use { for index, rule in local.egress_rules : index => rule }.
  egress_rules_by_index = {}
}

resource "terraform_data" "security_group" {
  input = {
    name = local.security_group_name
  }
}

resource "terraform_data" "ingress_rule" {
  for_each = local.ingress_rules_by_index

  input = {
    security_group = terraform_data.security_group.input.name
    name           = each.value.name
    direction      = each.value.direction
    from_port      = each.value.from_port
    to_port        = each.value.to_port
    protocol       = each.value.protocol
    cidr_block     = each.value.cidr_block
    description    = each.value.description
  }
}

resource "terraform_data" "egress_rule" {
  for_each = local.egress_rules_by_index

  input = {
    security_group = terraform_data.security_group.input.name
    name           = each.value.name
    direction      = each.value.direction
    from_port      = each.value.from_port
    to_port        = each.value.to_port
    protocol       = each.value.protocol
    cidr_block     = each.value.cidr_block
    description    = each.value.description
  }
}

output "rules" {
  description = "Rules decoded from data/sg-02.csv."
  value       = local.rules
}

output "ingress_rules" {
  description = "Ingress rules selected from the decoded CSV."
  value       = local.ingress_rules
}

output "egress_rules" {
  description = "Egress rules selected from the decoded CSV."
  value       = local.egress_rules
}

output "ingress_rules_by_index" {
  description = "Ingress rules keyed by list index for for_each."
  value       = local.ingress_rules_by_index
}

output "egress_rules_by_index" {
  description = "Egress rules keyed by list index for for_each."
  value       = local.egress_rules_by_index
}

output "ingress_rule_inputs" {
  description = "Mock ingress security group rule resources."
  value = {
    for key, rule in terraform_data.ingress_rule : key => rule.input
  }
}

output "egress_rule_inputs" {
  description = "Mock egress security group rule resources."
  value = {
    for key, rule in terraform_data.egress_rule : key => rule.input
  }
}
