resource "aws_vpc" "lab" {
  cidr_block = "10.132.0.0/16"

  tags = {
    Name = "tf-pro-lab-133"
  }
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.132.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-pro-133-a"
  }
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.132.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "tf-pro-133-b"
  }
}

data "aws_subnets" "lab" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.lab.id]
  }

  depends_on = [aws_subnet.a, aws_subnet.b]
}

data "aws_subnet" "first" {
  id = aws_subnet.a.id
}

output "subnet_ids" {
  value = data.aws_subnets.lab.ids
}

output "first_cidr" {
  value = data.aws_subnet.first.cidr_block
}
