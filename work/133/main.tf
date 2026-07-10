# Lab 133 知识点总结：
# - aws_subnets 是复数 data source，用 filter/tags 查询一组 subnet，核心返回值是 ids。
# - aws_subnet 是单数 data source，用 id 或足够精确的过滤条件读取一个 subnet 的详细属性。
# - 单数查询如果条件匹配多个 subnet 会报错；需要继续收紧条件，不能随意取“第一个”。
# - filter.name 使用底层 EC2 DescribeSubnets API 的过滤字段，例如 vpc-id、tag:Name。
# - filter.values 是可接受值的集合；多个 filter block 之间共同约束查询结果。
# - aws_subnets 返回的 ID 顺序不应被当成稳定业务契约，需要稳定展示时应显式 sort()。
# - 本实验先创建 VPC/subnet，再用 data source 查询，体现 resource 与 data 的职责差异。
# - 集合查询只引用 VPC ID，必须显式等待两个 subnet 创建完成，避免 apply 中过早读取。
# - 单对象查询直接引用 aws_subnet.a.id，Terraform 会自动建立隐式依赖。
# - LocalStack 可以验证 Terraform → AWS Provider → EC2 查询链路，但不替代真实 VPC 路由或网络连通性测试。
#
# aws_vpc.lab 已提供作为实验边界。请依次完成 TODO 1～4；每个 TODO 都有完整答案级 Hint。

resource "aws_vpc" "lab" {
  cidr_block = "10.132.0.0/16"

  tags = {
    Name = "tf-pro-lab-133"
  }
}

# TODO 1：在同一个 VPC 中创建两个不同 AZ、不同 CIDR 的 subnet。
# 答案级 Hint：完整答案如下，取消注释即可：
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

# TODO 2：使用复数 aws_subnets，按 vpc-id 查询刚创建的两个 subnet。
# 为什么需要 depends_on：filter 只引用 VPC ID，没有直接引用 subnet resource；显式依赖确保查询发生在二者创建之后。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# data "aws_subnets" "lab" {
#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.lab.id]
#   }
#
#   depends_on = [aws_subnet.a, aws_subnet.b]
# }

# TODO 3：使用单数 aws_subnet，按 aws_subnet.a.id 精确读取第一个 subnet 的详情。
# 这里不需要 depends_on，因为 id 引用已经建立隐式依赖。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# data "aws_subnet" "first" {
#   id = aws_subnet.a.id
# }

# TODO 4：输出排序后的集合查询结果，以及单对象查询返回的详细属性。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# output "subnet_ids" {
#   description = "Subnet IDs returned by aws_subnets, sorted only for stable display and testing."
#   value       = sort(data.aws_subnets.lab.ids)
# }
#
# output "subnet_count" {
#   description = "Number of subnets returned by the plural data source."
#   value       = length(data.aws_subnets.lab.ids)
# }
#
# output "first_subnet" {
#   description = "Detailed attributes returned by the singular aws_subnet data source."
#   value = {
#     id                = data.aws_subnet.first.id
#     cidr_block        = data.aws_subnet.first.cidr_block
#     availability_zone = data.aws_subnet.first.availability_zone
#     vpc_id            = data.aws_subnet.first.vpc_id
#   }
# }
