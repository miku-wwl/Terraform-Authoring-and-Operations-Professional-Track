# Lab 133 知识点总结：
# - `aws_subnets` 是复数 data source，适合按条件读取一组 subnet，常用返回值是 `ids`。
# - `aws_subnet` 是单数 data source，适合按 id 精确读取一个 subnet 的详细属性。
# - filter 的结构通常是 `filter { name = "..."; values = [...] }`。
# - 多个 data source 可以组合使用：先查集合，再精确读取单个对象属性。
# - 本实验先创建 VPC/subnet 作为查询目标，再用 data source 读取它们。

# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_vpc" "lab" {
  cidr_block = "10.132.0.0/16"

  tags = {
    Name = "tf-pro-lab-133"
  }
}

# TODO: 创建两个子网，并使用 data sources 查询它们。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_subnet" "a" {
#   vpc_id            = aws_vpc.lab.id
#   cidr_block        = "10.132.1.0/24"
#   availability_zone = "us-east-1a"
#
#   tags = {
#     Name = "tf-pro-133-a"
#   }
# }
#
# resource "aws_subnet" "b" {
#   vpc_id            = aws_vpc.lab.id
#   cidr_block        = "10.132.2.0/24"
#   availability_zone = "us-east-1b"
#
#   tags = {
#     Name = "tf-pro-133-b"
#   }
# }
#
# data "aws_subnets" "lab" {
#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.lab.id]
#   }
#
#   depends_on = [aws_subnet.a, aws_subnet.b]
# }
#
# data "aws_subnet" "first" {
#   id = aws_subnet.a.id
# }
#
# output "subnet_ids" {
#   value = data.aws_subnets.lab.ids
# }
#
# output "first_cidr" {
#   value = data.aws_subnet.first.cidr_block
# }
