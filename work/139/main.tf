# Lab 139 知识点总结：
# - EC2 Launch Template 保存可复用的实例启动参数，本身不会启动 EC2 instance。
# - 本节核心参数是 name、image_id、instance_type 和 vpc_security_group_ids。
# - vpc_security_group_ids 应引用真实 Security Group ID；引用同时建立 Security Group → Launch Template 依赖。
# - Launch Template 创建时不会完整验证 AMI、实例类型与参数组合；模板创建成功不代表未来实例一定能启动。
# - tag_specifications.resource_type="instance" 的 tags 属于未来实例，不是 Launch Template 自身的 tags。
# - resource 顶层 tags 才标记 Launch Template 对象；本 Lab 同时配置两层标签以观察边界。
# - Provider 状态可能包含额外 tag specification；读取实例标签时应按 resource_type 过滤。
# - Launch Template 使用不可变的编号版本；初次创建时 latest_version 和 default_version 通常都是 1。
# - 修改模板数据会创建新版本，而不是原地修改旧版本；ASG 等消费者必须明确使用 Default、Latest 或固定版本。
# - name 是稳定的明确名称；name_prefix 则让 AWS 追加唯一后缀，两者不能同时使用。
# - LocalStack 能验证 VPC、Security Group、Launch Template 与版本输出，但不验证真实 AMI 可用性或实例启动。
#
# VPC 与 Security Group 已提供为网络脚手架。请完成 TODO 1～2；每个 TODO 都有完整答案级 Hint。

resource "aws_vpc" "lab" {
  cidr_block = "10.139.0.0/16"
  tags       = { Name = "tf-pro-lab-139" }
}

resource "aws_security_group" "web" {
  name        = "tf-pro-lab-139-web"
  description = "Launch template dependency; no traffic rules are needed for this lab."
  vpc_id      = aws_vpc.lab.id
  tags        = { Name = "tf-pro-lab-139-web" }
}

locals {
  future_instance_tags = {
    Name = "tf-pro-lab-139-instance"
    Lab  = "139"
  }
}

# TODO 1：创建 Launch Template，保存 AMI、实例类型、安全组和未来实例标签。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_launch_template" "web" {
#   name                   = "tf-pro-lab-139-web"
#   description            = "Basic LocalStack launch template for Lab 139."
#   image_id               = "ami-12345678"
#   instance_type          = "t3.micro"
#   vpc_security_group_ids = [aws_security_group.web.id]
#
#   tag_specifications {
#     resource_type = "instance"
#     tags          = local.future_instance_tags
#   }
#
#   tags = {
#     Name = "tf-pro-lab-139-template"
#     Lab  = "139"
#   }
# }

# TODO 2：输出模板身份、版本和启动参数，区分模板标签与未来实例标签。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# output "launch_template_summary" {
#   description = "Identity, versions, and core launch parameters."
#   value = {
#     id                   = aws_launch_template.web.id
#     name                 = aws_launch_template.web.name
#     image_id             = aws_launch_template.web.image_id
#     instance_type        = aws_launch_template.web.instance_type
#     security_group_ids   = aws_launch_template.web.vpc_security_group_ids
#     latest_version       = aws_launch_template.web.latest_version
#     default_version      = aws_launch_template.web.default_version
#     launch_template_tags = aws_launch_template.web.tags
#     future_instance_tags = local.future_instance_tags
#   }
# }
