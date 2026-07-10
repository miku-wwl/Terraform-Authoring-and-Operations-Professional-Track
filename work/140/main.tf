# Lab 140 知识点总结：
# - Launch Template 定义“实例如何启动”，Auto Scaling Group 定义“保持多少实例、放在哪些子网”。
# - ASG 容量必须满足 min_size <= desired_capacity <= max_size。
# - VPC 模式下真实 aws_autoscaling_group 通常使用 vpc_zone_identifier 传入 subnet IDs，而不是只写 AZ 名称。
# - 多个不同 AZ 的 subnet 能让 ASG 分散容量；本 Lab 提供 us-east-1a/1b 两个网络脚手架。
# - launch_template block 通过 id/name 加 version 引用模板；版本可用 $Latest、$Default 或明确编号。
# - $Latest 方便但会让未来扩容自动采用最新版本；固定版本更可预测，需要显式升级流程。
# - desired_capacity 是目标实例数，min/max 是缩容和扩容边界；没有 scaling policy 时目标不会按指标自动变化。
# - Terraform local 只建模值，不调用 Auto Scaling API，也不会创建或维持任何 EC2 instance。
# - check block 能验证容量不变量，但不能替代 AWS API、实例健康检查、跨 AZ 调度和扩缩容验证。
# - LocalStack 4.2.0 Community 的 CreateAutoScalingGroup 不可用，因此本 Lab 不伪装成真实 ASG 成功。
#
# VPC、双 AZ subnet 和 Launch Template 已提供。请完成 TODO 1～2，写出接近真实 ASG block 的配置模型。

resource "aws_vpc" "lab" {
  cidr_block = "10.140.0.0/16"
  tags       = { Name = "tf-pro-lab-140" }
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.140.1.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "tf-pro-lab-140-a" }
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.140.2.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "tf-pro-lab-140-b" }
}

resource "aws_launch_template" "web" {
  name          = "tf-pro-lab-140-web"
  image_id      = "ami-12345678"
  instance_type = "t3.micro"
  tags          = { Lab = "140" }
}

# TODO 1：用 local.asg_spec 建模真实 aws_autoscaling_group 的核心参数。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# locals {
#   asg_spec = {
#     name                = "tf-pro-lab-140-web"
#     min_size            = 1
#     desired_capacity    = 2
#     max_size            = 3
#     vpc_zone_identifier = sort([aws_subnet.a.id, aws_subnet.b.id])
#     health_check_type   = "EC2"
#     launch_template = {
#       id      = aws_launch_template.web.id
#       version = "$Latest"
#     }
#   }
# }

# TODO 2：用 check 验证容量不变量，并输出模型。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# check "asg_capacity_order" {
#   assert {
#     condition = (
#       local.asg_spec.min_size <= local.asg_spec.desired_capacity &&
#       local.asg_spec.desired_capacity <= local.asg_spec.max_size
#     )
#     error_message = "ASG capacity must satisfy min_size <= desired_capacity <= max_size."
#   }
# }
#
# output "asg_spec" {
#   description = "ASG configuration model; no Auto Scaling API call is made in this LocalStack-limited lab."
#   value       = local.asg_spec
# }
