# Lab 139 知识点总结：
# - Launch Template 用来保存 EC2 启动参数，例如 AMI、实例类型、标签等。
# - `name_prefix` 让 AWS/Terraform 自动生成不冲突的模板名。
# - `tag_specifications` 是给将来由模板启动出来的资源打标签。
# - `latest_version` 会随着模板内容变更而更新，后续 ASG 常会引用它。

# TODO: 创建 aws_launch_template，并输出 launch_template_id。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_launch_template" "web" {
#   name_prefix   = "tf-pro-lab-139-"
#   image_id      = "ami-12345678"
#   instance_type = "t2.micro"
#
#   tag_specifications {
#     resource_type = "instance"
#
#     tags = {
#       Name = "tf-pro-lab-139"
#     }
#   }
# }
#
# output "launch_template_id" {
#   value = aws_launch_template.web.id
# }
#
# output "launch_template_latest_version" {
#   value = aws_launch_template.web.latest_version
# }
