resource "aws_launch_template" "web" {
  name_prefix   = "tf-pro-lab-140-"
  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

locals {
  asg_spec = {
    name               = "tf-pro-lab-140-web"
    availability_zones = ["us-east-1a"]
    min_size           = 1
    max_size           = 2
    desired_capacity   = 1
    launch_template_id = aws_launch_template.web.id
    launch_version     = "$Latest"
  }
}

output "launch_template_id" {
  value = aws_launch_template.web.id
}

output "asg_spec" {
  value = local.asg_spec
}
