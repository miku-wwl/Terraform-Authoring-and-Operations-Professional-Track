# Lab 141 知识点总结：
# - S3 bucket policy 是直接附着在 Bucket 上的 resource-based policy，必须表达 Principal。
# - identity-based policy 回答“某身份能访问什么”；bucket policy 从资源侧回答“谁能对这个 Bucket 做什么”。
# - s3:ListBucket 是 bucket-level action，Resource 必须是 bucket ARN。
# - s3:GetObject 是 object-level action，Resource 必须是 `${bucket_arn}/*`。
# - 不应把两类 Action/Resource 混进同一 statement，否则会产生无效或过宽的 Action-Resource 配对。
# - principals.type="AWS" 可指定账号、User 或 Role ARN；本 Lab 只信任 LocalStack 模拟账号 root principal。
# - `arn:aws:iam::000000000000:root` 表示该账号主体边界，不等于只允许 root 用户本人。
# - aws_iam_policy_document 只生成 JSON；aws_s3_bucket_policy 才调用 PutBucketPolicy 绑定到 Bucket。
# - bucket 参数引用 aws_s3_bucket.logs.id，policy 引用 data source `.json`，形成正确依赖关系。
# - Principal="*" 会形成公共信任边界，不能为了省事使用；真实 S3 还受 Block Public Access 等控制。
# - LocalStack 可验证 Bucket/Policy API 和 JSON 语义，但不能替代真实跨账号、SCP、KMS 或 Block Public Access 测试。
#
# Bucket 已提供作为实验边界。请完成 TODO 1～3；每个 TODO 都有完整答案级 Hint。

resource "aws_s3_bucket" "logs" {
  bucket = "tf-pro-lab-141-logs"
  tags = {
    Course = "terraform-pro"
    Lab    = "141"
  }
}

# TODO 1：用两条 statement 分别授权 bucket-level ListBucket 与 object-level GetObject。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# data "aws_iam_policy_document" "bucket_read" {
#   statement {
#     sid       = "AllowBucketListing"
#     effect    = "Allow"
#     actions   = ["s3:ListBucket"]
#     resources = [aws_s3_bucket.logs.arn]
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::000000000000:root"]
#     }
#   }
#
#   statement {
#     sid       = "AllowObjectReads"
#     effect    = "Allow"
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.logs.arn}/*"]
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::000000000000:root"]
#     }
#   }
# }

# TODO 2：把生成 JSON 绑定到当前 Bucket。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# resource "aws_s3_bucket_policy" "logs" {
#   bucket = aws_s3_bucket.logs.id
#   policy = data.aws_iam_policy_document.bucket_read.json
# }

# TODO 3：输出绑定关系和解码后的策略语义。
# 答案级 Hint：完整答案如下，取消注释即可：
#
# output "bucket_policy_relationship" {
#   description = "Bucket and policy resource binding."
#   value = {
#     bucket_name   = aws_s3_bucket.logs.bucket
#     bucket_arn    = aws_s3_bucket.logs.arn
#     policy_bucket = aws_s3_bucket_policy.logs.bucket
#   }
# }
#
# output "bucket_policy_document" {
#   description = "Bucket policy decoded for Action/Resource/Principal verification."
#   value       = jsondecode(data.aws_iam_policy_document.bucket_read.json)
# }
