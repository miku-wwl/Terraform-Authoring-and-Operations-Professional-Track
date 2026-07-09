# Module buckets 知识点总结：
# - 子模块中的资源默认使用调用方传入的默认 provider，也就是这里的 aws。
# - 某个资源要使用 alias provider 时，需要显式写 provider = aws.prod。
# - provider = aws.prod 只影响当前 resource，不会改变整个模块的默认 provider。
# - 子模块暴露 output 后，root module 可以通过 module.buckets.<OUTPUT_NAME> 读取结果。
#
# 这个子模块不写 provider "aws" 配置。
# 它只在 resource 上选择“使用默认 aws”还是“使用 aws.prod”。
#
# resource 没写 provider = ... 时，默认使用调用方传入的 aws。
# resource 写 provider = aws.prod 时，只这个资源使用调用方传入的 aws.prod。
#
# bucket 名称来自变量 var.bucket_names。
# provider 选择来自 resource 上是否写 provider = aws.prod。

# TODO: 创建两个 S3 bucket，其中 dev 使用默认 provider，prod 使用 aws.prod。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "dev" {
#   # 没写 provider，所以使用默认 aws provider。
#   bucket = var.bucket_names.dev
# }
#
# resource "aws_s3_bucket" "prod" {
#   # 只让这个资源使用 alias provider。
#   provider = aws.prod
#   bucket   = var.bucket_names.prod
# }
#
# output "bucket_names" {
#   value = [aws_s3_bucket.dev.bucket, aws_s3_bucket.prod.bucket]
# }
