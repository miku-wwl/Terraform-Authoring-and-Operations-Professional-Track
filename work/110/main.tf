# Lab 110 知识点总结：
# - provider alias 用来在同一个 Terraform 配置中定义同类型 provider 的多个实例。
# - 没有 alias 的 provider 是默认 provider，资源不写 provider 时会使用它。
# - 带 alias 的 provider 通过 provider = aws.<ALIAS> 显式选择。
# - 本实验中默认 provider 表示 ap-southeast-1，alias provider aws.usa 表示 us-east-1。
# - provider meta argument 只影响当前 resource，不会改变其他资源的默认 provider。

# TODO: 创建两个 S3 bucket，其中一个使用默认 provider，另一个使用 aws.usa。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "singapore" {
#   bucket = "tf-pro-lab-110-a"
# }
#
# resource "aws_s3_bucket" "usa" {
#   provider = aws.usa
#   bucket   = "tf-pro-lab-110-b"
# }
#
# output "bucket_names" {
#   value = [aws_s3_bucket.singapore.bucket, aws_s3_bucket.usa.bucket]
# }
