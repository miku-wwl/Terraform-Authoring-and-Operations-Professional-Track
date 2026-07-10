# Lab 113 知识点总结：
# - 默认 aws provider 代表基础身份，aws.assumed 代表扮演 Role 后的临时身份。
# - provider alias 让同一份配置可以同时观察这两个身份。
# - data.aws_caller_identity 会返回当前 provider 实际使用的 account_id、arn 和 user_id。
# - resource 中写 provider = aws.assumed，资源才会使用扮演后的身份创建。
# - 真实跨账号场景需要双向授权：
#   1. A 账号身份的 IAM policy 允许对 B 账号目标 Role 执行 sts:AssumeRole。
#   2. B 账号目标 Role 的 trust policy 信任 A 账号身份，允许它扮演该 Role。
# - 本实验的 bootstrap 脚本会创建目标 Role 和 trust policy。
# - LocalStack 使用测试基础身份，因此本实验没有单独创建 A 账号的 IAM policy。

data "aws_caller_identity" "base" {}

data "aws_caller_identity" "assumed" {
  provider = aws.assumed
}

resource "aws_s3_bucket" "assumed" {
  provider = aws.assumed
  bucket   = "tf-pro-lab-113"
}

output "identity_comparison" {
  value = {
    base_arn    = data.aws_caller_identity.base.arn
    assumed_arn = data.aws_caller_identity.assumed.arn
    changed     = data.aws_caller_identity.base.arn != data.aws_caller_identity.assumed.arn
  }
}

output "bucket_name" {
  value = aws_s3_bucket.assumed.bucket
}
