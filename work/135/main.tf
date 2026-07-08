# Lab 135 知识点总结：
# - IAM policy 用 JSON 表达权限；Terraform 中常用 `jsonencode` 生成 JSON。
# - `aws_iam_policy` 创建可复用的托管策略。
# - `aws_iam_user_policy_attachment` 把托管策略绑定到 IAM user。
# - 资源之间通过 user name 和 policy ARN 建立引用关系。

# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_iam_user" "reader" {
  name = "tf-pro-lab-135-reader"
}

# TODO: 创建只读 S3 policy，并绑定到用户。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_iam_policy" "s3_read" {
#   name        = "tf-pro-lab-135-s3-read"
#   description = "允许读取 S3 bucket 列表和对象的练习策略"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:ListBucket"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_user_policy_attachment" "reader" {
#   user       = aws_iam_user.reader.name
#   policy_arn = aws_iam_policy.s3_read.arn
# }
#
# output "reader_name" {
#   value = aws_iam_user.reader.name
# }
#
# output "policy_arn" {
#   value = aws_iam_policy.s3_read.arn
# }
