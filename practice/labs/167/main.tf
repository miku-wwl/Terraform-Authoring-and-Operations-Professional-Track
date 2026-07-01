resource "aws_vpc" "central" {
  cidr_block = "10.167.0.0/16"
}

resource "aws_security_group" "app" {
  name   = "tf-pro-167-sg"
  vpc_id = aws_vpc.central.id
}

locals {
  rules = {
    for index, row in csvdecode(file("sg.csv")) : index => {
      cidr_ipv4   = row.cidr
      ip_protocol = row.protocol
      from_port   = tonumber(split("-", row.port)[0])
      to_port     = tonumber(try(split("-", row.port)[1], split("-", row.port)[0]))
    } if row.direction == "in"
  }
}

resource "aws_vpc_security_group_ingress_rule" "csv" {
  for_each          = local.rules
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
}

output "ingress_rule_count" {
  value = length(aws_vpc_security_group_ingress_rule.csv)
}

output "ingress_rules" {
  value = local.rules
}
