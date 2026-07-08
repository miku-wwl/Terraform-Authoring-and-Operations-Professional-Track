# Lab 141 知识点总结：
# - S3 bucket policy 是资源策略，直接绑定在 bucket 上。
# - 资源策略通常要同时写清楚 actions、resources 和 principals。
# - bucket ARN 表示 bucket 本身，`${bucket_arn}/*` 表示 bucket 里的对象。
# - `aws_s3_bucket_policy.policy` 接收 policy JSON 字符串。

resource "aws_s3_bucket" "logs" {
  bucket = "tf-pro-lab-141-logs"
}

# TODO: 使用 aws_iam_policy_document 生成 bucket policy，并绑定到 bucket。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "aws_iam_policy_document" "bucket_read" {
#   statement {
#     sid    = "AllowReadFromExamplePrincipal"
#     effect = "Allow"
#
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket"
#     ]
#
#     resources = [
#       aws_s3_bucket.logs.arn,
#       "${aws_s3_bucket.logs.arn}/*"
#     ]
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::000000000000:root"]
#     }
#   }
# }
#
# resource "aws_s3_bucket_policy" "logs" {
#   bucket = aws_s3_bucket.logs.id
#   policy = data.aws_iam_policy_document.bucket_read.json
# }
#
# output "bucket_name" {
#   value = aws_s3_bucket.logs.bucket
# }
#
# output "bucket_policy" {
#   value = data.aws_iam_policy_document.bucket_read.json
# }
