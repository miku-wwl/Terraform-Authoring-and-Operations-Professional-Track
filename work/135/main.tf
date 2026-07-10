# Lab 135 知识点总结：
# - IAM identity-based policy 是描述 Allow/Deny、Action、Resource 和 Condition 的 JSON 权限文档。
# - aws_iam_policy 创建 customer managed policy：它是独立 IAM 对象，有自己的 ARN，可复用到多个 User、Group 或 Role。
# - aws_iam_user_policy_attachment 把 managed policy 与 User 连接；策略存在不等于已经授予该用户权限。
# - aws_iam_user_policy 创建 inline policy：它没有独立 ARN，与指定 User 保持一对一生命周期关系。
# - Terraform policy 参数要求 JSON 字符串；jsonencode() 可把 HCL object/list 转成合法 JSON。
# - file() 可读取已经由外部工具维护或验证的 JSON policy；路径通常使用 ${path.module} 避免依赖当前工作目录。
# - heredoc 也能提供 JSON 字符串，但需要手工保证引号、逗号和转义正确；本 Lab 只讲其边界，不重复练同一种结果。
# - resource reference 同时传值并建立依赖：attachment 应引用 User name 和 Policy ARN，不应手写 ARN。
# - S3 ListBucket 作用于 bucket ARN，GetObject 作用于 object ARN；把所有 Resource 都写成 "*" 不符合最小权限思路。
# - 多个 Allow policy 的权限通常取并集，但显式 Deny、permissions boundary、SCP 等仍可能限制最终权限。
# - LocalStack 能验证资源、JSON 文档、attachment 和销毁闭环，但不能替代真实 AWS 的 IAM policy evaluation 或 Access Analyzer。
#
# aws_iam_user.reader 已提供作为实验起点。请依次完成 TODO 1～4；每个 TODO 都有完整答案级 Hint。

resource "aws_iam_user" "reader" {
  name = "tf-pro-lab-135-reader"

  tags = {
    Course = "terraform-pro"
    Lab    = "135"
  }
}

# TODO 1：使用 jsonencode 创建可复用的 customer managed policy。
# 注意：ListBucket 与 GetObject 需要不同层级的 S3 ARN，因此拆成两个 Statement。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_iam_policy" "s3_read" {
#   name        = "tf-pro-lab-135-s3-read"
#   description = "Read-only access to the lab S3 bucket and its objects."
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid      = "ListBucket"
#         Effect   = "Allow"
#         Action   = ["s3:ListBucket"]
#         Resource = ["arn:aws:s3:::tf-pro-lab-135-shared"]
#       },
#       {
#         Sid      = "ReadObjects"
#         Effect   = "Allow"
#         Action   = ["s3:GetObject"]
#         Resource = ["arn:aws:s3:::tf-pro-lab-135-shared/*"]
#       }
#     ]
#   })
#
#   tags = {
#     Course = "terraform-pro"
#     Lab    = "135"
#   }
# }

# TODO 2：把 managed policy 绑定到 reader。
# 两个参数都使用 resource reference：Terraform 会据此建立 User、Policy → Attachment 的依赖。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_iam_user_policy_attachment" "reader_s3_read" {
#   user       = aws_iam_user.reader.name
#   policy_arn = aws_iam_policy.s3_read.arn
# }

# TODO 3：给 reader 创建一份一对一的 inline policy，并用 file() 读取现成 JSON。
# policies/ec2-describe.json 已提供，重点是区分 inline policy 与 managed policy 的生命周期。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_iam_user_policy" "ec2_describe" {
#   name   = "tf-pro-lab-135-ec2-describe"
#   user   = aws_iam_user.reader.name
#   policy = file("${path.module}/policies/ec2-describe.json")
# }

# TODO 4：输出绑定关系和两份解码后的 policy document，便于检查实际语义而不是只检查字符串存在。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# output "policy_relationships" {
#   description = "Managed-policy attachment and inline-policy ownership relationships."
#   value = {
#     user_name           = aws_iam_user.reader.name
#     managed_policy_arn  = aws_iam_policy.s3_read.arn
#     attached_user       = aws_iam_user_policy_attachment.reader_s3_read.user
#     attached_policy_arn = aws_iam_user_policy_attachment.reader_s3_read.policy_arn
#     inline_policy_name  = aws_iam_user_policy.ec2_describe.name
#     inline_policy_owner = aws_iam_user_policy.ec2_describe.user
#   }
# }
#
# output "managed_policy_document" {
#   description = "Decoded customer managed policy for semantic verification."
#   value       = jsondecode(aws_iam_policy.s3_read.policy)
# }
#
# output "inline_policy_document" {
#   description = "Decoded inline policy loaded from policies/ec2-describe.json."
#   value       = jsondecode(aws_iam_user_policy.ec2_describe.policy)
# }
