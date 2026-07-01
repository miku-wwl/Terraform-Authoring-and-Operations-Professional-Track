variable "user_name" { type = string }
resource "aws_iam_user" "this" { name = var.user_name }
output "user_name" { value = aws_iam_user.this.name }
