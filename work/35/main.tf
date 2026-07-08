# Lab 35 知识点总结：
# - 本实验把 data source 的查询结果交给 resource 使用，而不是只把查询结果输出出来。
# - AMI ID 不应硬编码；先用 data "aws_ami" 查询当前 region 最新可用 AMI。
# - resource "aws_instance" 的 ami 可以直接引用 data.aws_ami.latest.id。
# - Terraform 会根据引用关系自动建立依赖：先读取 AMI，再用这个 AMI 创建 EC2。
# - 这种写法让同一份配置更容易适配不同 region 或不同时间更新的镜像。

# TODO：声明 data "aws_ami" "latest"，匹配 tf-lab-app-*-x86_64。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "aws_ami" "latest" {
#   most_recent = true
#   owners      = ["self"]
#
#   filter {
#     name   = "name"
#     values = ["tf-lab-app-*-x86_64"]
#   }
# }
#
# TODO：创建 aws_instance "app"。
# 要求：
# - ami 引用 data.aws_ami.latest.id
# - instance_type 使用 t3.micro
# - tag Name=tf-lab-35-instance
# - tag Project=tf-lab-35
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_instance" "app" {
#   ami           = data.aws_ami.latest.id
#   instance_type = "t3.micro"
#
#   tags = {
#     Name    = "tf-lab-35-instance"
#     Project = "tf-lab-35"
#   }
# }
