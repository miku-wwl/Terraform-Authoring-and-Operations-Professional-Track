# Lab 137 知识点总结：
# - IAM role 必须有 trust policy，也叫 assume role policy。
# - trust policy 回答的是“谁可以扮演这个 role”，不是“这个 role 有什么权限”。
# - `principals` 用来指定可信主体；EC2 服务主体是 `ec2.amazonaws.com`。
# - `assume_role_policy` 接收的是 trust policy 的 JSON 字符串。

# TODO: 创建允许 EC2 服务 assume role 的 trust policy 和 IAM role。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "aws_iam_policy_document" "ec2_trust" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }
#
# resource "aws_iam_role" "ec2" {
#   name               = "tf-pro-lab-137-ec2-role"
#   assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
# }
#
# output "role_name" {
#   value = aws_iam_role.ec2.name
# }
#
# output "role_arn" {
#   value = aws_iam_role.ec2.arn
# }
