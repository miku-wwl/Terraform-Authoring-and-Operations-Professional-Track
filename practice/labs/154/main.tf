variable "environment" {
  type    = string
  default = "production"
}

locals {
  users   = ["app", "platform", "security"]
  buckets = toset(["tf-pro-154-a", "tf-pro-154-b"])
}

resource "aws_iam_user" "team" {
  count = length(local.users)
  name  = "tf-pro-154-${local.users[count.index]}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_user_policy" "describe_ec2" {
  count = length(aws_iam_user.team)
  name  = "describe-ec2"
  user  = aws_iam_user.team[count.index].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ec2:Describe*"
      Resource = "*"
    }]
  })
}

resource "aws_s3_bucket" "challenge" {
  for_each = local.buckets
  bucket   = each.value
}

resource "aws_vpc" "challenge" {
  cidr_block = "10.154.0.0/16"
}

resource "aws_security_group" "challenge" {
  name        = "tf-pro-154-sg"
  description = "challenge one security group"
  vpc_id      = aws_vpc.challenge.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.challenge.id
  cidr_ipv4         = "10.154.0.0/16"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

output "s3_buckets" {
  value = [for bucket in aws_s3_bucket.challenge : bucket.bucket]
}

output "user_names" {
  value = aws_iam_user.team[*].name
}

output "sg_id" {
  value = aws_security_group.challenge.id
}

output "sg_rule_id" {
  value = aws_vpc_security_group_ingress_rule.http.id
}
