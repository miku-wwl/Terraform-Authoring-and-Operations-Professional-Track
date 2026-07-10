# Lab 138 知识点总结：
# - aws_iam_role 的 trust policy 决定谁能扮演角色；本 Lab 已提供只信任 lambda.amazonaws.com 的 Role。
# - aws_iam_policy 创建独立、可复用、有 ARN 的 customer managed permissions policy。
# - aws_iam_role_policy_attachment 把一份 managed policy 附加到一个 Role，调用的是 IAM AttachRolePolicy 语义。
# - attachment.role 需要 Role name，不是 Role ARN；attachment.policy_arn 需要 managed policy ARN，不是 policy name。
# - 使用 aws_iam_role.lambda.name 和 aws_iam_policy.logs.arn 会同时传值并建立两条隐式依赖。
# - 创建 policy 本身不会让 Role 获得权限；只有 attachment 建立后，它才成为该 Role 的 permissions policy。
# - trust policy 不能通过 managed policy attachment 替代；assume_role_policy 与 permissions attachment 是不同 API 边界。
# - aws_iam_role_policy_attachment 管理一条 attachment，不会独占 Role 的全部 managed policy 集合。
# - 不要和 aws_iam_policy_attachment 混用；后者具有跨身份的独占附件语义，容易产生意外移除和永久 diff。
# - 也不要同时使用已弃用的 aws_iam_role.managed_policy_arns 与独立 attachment resource 管理同一关系。
# - 本 Lab 的 Logs Action 只是 IAM JSON 内容，不创建 Log Group，也不调用 CloudWatch Logs API。
# - 本 Lab 用 jsonencode 生成 policy，因此单元素 Action/Resource 数组会保留；这与 Lab 136 policy_document 的规范化行为不同。
# - LocalStack 能验证 Role、Policy、Attachment 和销毁顺序，但不证明 Lambda 运行时或最终权限评估正确。
#
# Lambda trust policy 和 Role 已提供作为 Lab 137 的复习边界。本 Lab 只完成 TODO 1～3。

data "aws_iam_policy_document" "lambda_trust" {
  statement {
    sid     = "AllowLambdaAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "tf-pro-lab-138-lambda-role"
  description        = "Disposable LocalStack Lambda execution role for attachment practice."
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  tags = {
    Course = "terraform-pro"
    Lab    = "138"
  }
}

# TODO 1：创建一份独立的 customer managed permissions policy。
# CreateLogGroup 不支持资源级限定，因此本示例使用 Resource="*"。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_iam_policy" "logs" {
#   name        = "tf-pro-lab-138-logs"
#   description = "Allow the lab Lambda role to create CloudWatch Log Groups."
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Sid      = "CreateLogGroup"
#       Effect   = "Allow"
#       Action   = ["logs:CreateLogGroup"]
#       Resource = ["*"]
#     }]
#   })
#
#   tags = {
#     Course = "terraform-pro"
#     Lab    = "138"
#   }
# }

# TODO 2：使用独立 attachment resource 把 managed policy 绑定到 Lambda Role。
# role 使用 name，policy_arn 使用 arn；两个引用同时建立依赖。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_iam_role_policy_attachment" "logs" {
#   role       = aws_iam_role.lambda.name
#   policy_arn = aws_iam_policy.logs.arn
# }

# TODO 3：输出 attachment 两端和 permissions policy 语义，以便验证绑定的不是错误 Role/Policy。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# output "attachment_relationship" {
#   description = "Role and managed policy connected by aws_iam_role_policy_attachment."
#   value = {
#     role_name             = aws_iam_role.lambda.name
#     managed_policy_arn    = aws_iam_policy.logs.arn
#     attachment_role       = aws_iam_role_policy_attachment.logs.role
#     attachment_policy_arn = aws_iam_role_policy_attachment.logs.policy_arn
#   }
# }
#
# output "trust_service" {
#   description = "Service principal trusted to assume the role; separate from attached permissions."
#   value       = jsondecode(aws_iam_role.lambda.assume_role_policy).Statement[0].Principal.Service
# }
#
# output "permissions_document" {
#   description = "Managed permissions policy decoded for semantic verification."
#   value       = jsondecode(aws_iam_policy.logs.policy)
# }
