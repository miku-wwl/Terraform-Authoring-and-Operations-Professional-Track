variable "user_count" {
  type = number
}

resource "aws_iam_user" "this" {
  count = var.user_count
  name  = "tf-pro-lab-104-user-${count.index}"
}

output "user_names" {
  value = aws_iam_user.this[*].name
}
