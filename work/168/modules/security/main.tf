variable "vpc_id" {
  type = string
}

resource "aws_security_group" "this" {
  name   = "tf-pro-168-sg"
  vpc_id = var.vpc_id
}

output "security_group_id" {
  value = aws_security_group.this.id
}
