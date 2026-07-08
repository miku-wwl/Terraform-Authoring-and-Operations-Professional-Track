# Lab 134 知识点总结：
# - `aws_iam_user` 创建 IAM 用户。
# - `aws_iam_user_login_profile` 为用户创建控制台登录配置。
# - `aws_iam_access_key` 为用户创建编程访问密钥。
# - 密码、访问密钥等敏感信息必须在 output 中设置 `sensitive = true`。
# - 真实环境中不要把密钥明文提交到代码库或日志中。

# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_iam_user" "operator" {
  name = "tf-pro-lab-134-operator"
}

# TODO: 创建 login profile、access key，并把敏感输出标记为 sensitive。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_iam_user_login_profile" "operator" {
#   user                    = aws_iam_user.operator.name
#   password_length         = 20
#   password_reset_required = true
# }
#
# resource "aws_iam_access_key" "operator" {
#   user = aws_iam_user.operator.name
# }
#
# output "iam_user_name" {
#   value = aws_iam_user.operator.name
# }
#
# output "access_key_id" {
#   value     = aws_iam_access_key.operator.id
#   sensitive = true
# }
#
# output "encrypted_password" {
#   value     = aws_iam_user_login_profile.operator.encrypted_password
#   sensitive = true
# }
