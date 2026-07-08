# Lab 109 知识点总结：
# - 本实验让 Terraform AWS Provider 使用 named profile 创建资源。
# - provider 中的 profile = "lab" 会从 shared config/credentials 文件里读取 lab profile。
# - named profile 把凭证来源从 Terraform 配置中移出去，provider 只声明“用哪个 profile”。
# - 本实验仍然使用 LocalStack 的测试凭证，不访问真实 AWS。

# TODO: 使用 provider profile 创建一个 S3 bucket。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "profile" {
#   bucket = "tf-pro-lab-109"
# }
#
# output "bucket_name" {
#   value = aws_s3_bucket.profile.bucket
# }
