resource "aws_iam_user" "platform" {
  name = "tf-pro-lab-105-platform"
}

output "user_name" {
  value = aws_iam_user.platform.name
}
