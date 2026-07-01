resource "aws_vpc" "central" {
  cidr_block = "10.166.0.0/16"

  tags = {
    Name = "tf-pro-166-central"
  }
}

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.central.id
  cidr_block        = "10.166.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "app-subnet"
  }
}

resource "aws_subnet" "database" {
  vpc_id            = aws_vpc.central.id
  cidr_block        = "10.166.20.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "database-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.central.id
}

output "subnet_ids" {
  value = [aws_subnet.app.id, aws_subnet.database.id]
}
