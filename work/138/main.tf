# Lab 138 知识点总结：
# - IAM role 本身先解决“谁可以扮演我”，这里让 Lambda 服务 assume role。
# - IAM policy 解决“扮演之后能做什么”，这里授予 CloudWatch Logs 权限。
# - `aws_iam_role_policy_attachment` 负责把 managed policy 绑定到 role。
# - attachment 中 `role` 通常填 role name，`policy_arn` 填 policy ARN。

# TODO: 创建 role、policy，并使用 aws_iam_role_policy_attachment 绑定。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "aws_iam_policy_document" "lambda_trust" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#   }
# }
#
# resource "aws_iam_role" "lambda" {
#   name               = "tf-pro-lab-138-lambda-role"
#   assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
# }
#
# resource "aws_iam_policy" "logs" {
#   name = "tf-pro-lab-138-logs"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = ["logs:CreateLogGroup"]
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "logs" {
#   role       = aws_iam_role.lambda.name
#   policy_arn = aws_iam_policy.logs.arn
# }
#
# output "role_name" {
#   value = aws_iam_role.lambda.name
# }
#
# output "attached_policy_arn" {
#   value = aws_iam_policy.logs.arn
# }
