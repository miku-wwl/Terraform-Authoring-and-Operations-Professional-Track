resource "aws_iam_user" "operator" {
  name = "tf-pro-lab-134-operator"

  tags = {
    Course = "terraform-pro"
  }
}

resource "aws_iam_user_login_profile" "operator" {
  user                    = aws_iam_user.operator.name
  password_length         = 20
  password_reset_required = true
}

resource "aws_iam_access_key" "operator" {
  user = aws_iam_user.operator.name
}

output "iam_user_name" {
  value = aws_iam_user.operator.name
}

output "access_key_id" {
  value     = aws_iam_access_key.operator.id
  sensitive = true
}

output "encrypted_password" {
  value     = aws_iam_user_login_profile.operator.encrypted_password
  sensitive = true
}
