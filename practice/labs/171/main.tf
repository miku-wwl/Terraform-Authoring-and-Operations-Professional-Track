resource "aws_vpc" "central" {
  cidr_block = "10.171.0.0/16"

  tags = {
    Name = "central-vpc"
  }
}

resource "aws_subnet" "app" {
  vpc_id     = aws_vpc.central.id
  cidr_block = "10.171.10.0/24"

  tags = {
    Name = "app-subnet"
  }
}

resource "aws_subnet" "database" {
  vpc_id     = aws_vpc.central.id
  cidr_block = "10.171.20.0/24"

  tags = {
    Name = "database-subnet"
  }
}

resource "aws_subnet" "central" {
  vpc_id     = aws_vpc.central.id
  cidr_block = "10.171.30.0/24"

  tags = {
    Name = "central-subnet"
  }
}

data "aws_subnet" "app" {
  id = aws_subnet.app.id
}

data "aws_subnet" "database" {
  id = aws_subnet.database.id
}

data "aws_subnet" "central" {
  id = aws_subnet.central.id
}

resource "aws_security_group" "main" {
  name   = "tf-pro-171-sg"
  vpc_id = aws_vpc.central.id
}

locals {
  subnet_cidr = {
    app        = data.aws_subnet.app.cidr_block
    database   = data.aws_subnet.database.cidr_block
    antivirus  = data.aws_subnet.central.cidr_block
    monitoring = data.aws_subnet.central.cidr_block
  }
  ingress_rules = {
    for index, row in csvdecode(file("sg.csv")) : index => {
      cidr_ipv4   = local.subnet_cidr[row.cidr_key]
      ip_protocol = row.protocol
      from_port   = tonumber(split("-", row.port)[0])
      to_port     = tonumber(try(split("-", row.port)[1], split("-", row.port)[0]))
    } if row.direction == "in"
  }
}

resource "aws_vpc_security_group_ingress_rule" "csv" {
  for_each          = local.ingress_rules
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
}

output "subnet_ids" {
  value = {
    app      = data.aws_subnet.app.id
    database = data.aws_subnet.database.id
    central  = data.aws_subnet.central.id
  }
}

output "rule_summary" {
  value = local.ingress_rules
}
