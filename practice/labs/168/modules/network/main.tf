resource "aws_vpc" "this" {
  cidr_block = "10.168.0.0/16"
}

resource "aws_subnet" "app" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.168.10.0/24"
}

output "vpc_id" {
  value = aws_vpc.this.id
}
