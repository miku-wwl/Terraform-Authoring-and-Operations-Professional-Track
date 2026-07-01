# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_launch_template" "web" {
  name_prefix   = "tf-pro-lab-140-"
  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

# TODO: LocalStack Community 不支持真实创建 ASG。
# 请用 local.asg_spec 建模 ASG 关键字段，并输出 launch_template_id 与 asg_spec。
