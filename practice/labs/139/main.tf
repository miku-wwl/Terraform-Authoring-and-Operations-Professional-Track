resource "aws_launch_template" "web" {
  name_prefix   = "tf-pro-lab-139-"
  image_id      = "ami-12345678"
  instance_type = "t2.micro"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tf-pro-lab-139"
    }
  }
}

output "launch_template_id" {
  value = aws_launch_template.web.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.web.latest_version
}
