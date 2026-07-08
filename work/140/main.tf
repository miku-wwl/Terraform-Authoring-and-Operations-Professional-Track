# Lab 140 知识点总结：
# - Auto Scaling Group 使用 Launch Template 来知道“要启动什么样的 EC2”。
# - ASG 关键字段包括 min_size、max_size、desired_capacity 和 launch template 引用。
# - LocalStack Community 不支持真实创建 ASG，所以本 lab 用 `local.asg_spec` 建模。
# - `locals` 不会创建云资源，只是在 Terraform 配置中保存可引用的结构化值。

resource "aws_launch_template" "web" {
  name_prefix   = "tf-pro-lab-140-"
  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

# TODO: LocalStack Community 不支持真实创建 ASG。
# 请用 local.asg_spec 建模 ASG 关键字段，并输出 launch_template_id 与 asg_spec。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# locals {
#   asg_spec = {
#     name               = "tf-pro-lab-140-web"
#     availability_zones = ["us-east-1a"]
#     min_size           = 1
#     max_size           = 2
#     desired_capacity   = 1
#     launch_template_id = aws_launch_template.web.id
#     launch_version     = "$Latest"
#   }
# }
#
# output "launch_template_id" {
#   value = aws_launch_template.web.id
# }
#
# output "asg_spec" {
#   value = local.asg_spec
# }
