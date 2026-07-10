# Lab 113 知识点总结：
# - 默认 aws provider 代表基础身份，aws.assumed 代表扮演 Role 后的临时身份。
# - provider alias 让同一份配置可以同时观察这两个身份。
# - data.aws_caller_identity 会返回当前 provider 实际使用的 account_id、arn 和 user_id。
# - resource 中写 provider = aws.assumed，资源才会使用扮演后的身份创建。
# - 真实跨账号场景还需要：目标 Role 的 trust policy 允许来源身份执行 sts:AssumeRole。

# TODO 1：分别读取基础 provider 和 assumed provider 的调用者身份。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "aws_caller_identity" "base" {}
#
# data "aws_caller_identity" "assumed" {
#   provider = aws.assumed
# }

# TODO 2：明确使用 aws.assumed provider 创建 S3 bucket。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "assumed" {
#   provider = aws.assumed
#   bucket   = "tf-pro-lab-113"
# }

# TODO 3：输出身份对比和 bucket 名称，观察 AssumeRole 的结果。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# output "identity_comparison" {
#   value = {
#     base_arn    = data.aws_caller_identity.base.arn
#     assumed_arn = data.aws_caller_identity.assumed.arn
#     changed     = data.aws_caller_identity.base.arn != data.aws_caller_identity.assumed.arn
#   }
# }
#
# output "bucket_name" {
#   value = aws_s3_bucket.assumed.bucket
# }
