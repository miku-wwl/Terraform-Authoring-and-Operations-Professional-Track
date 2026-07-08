# Module buckets 知识点总结：
# - 子模块中的资源默认使用调用方传入的默认 provider，也就是这里的 aws。
# - 某个资源要使用 alias provider 时，需要显式写 provider = aws.prod。
# - provider = aws.prod 只影响当前 resource，不会改变整个模块的默认 provider。
# - 子模块暴露 output 后，root module 可以通过 module.buckets.<OUTPUT_NAME> 读取结果。

# TODO: 创建两个 S3 bucket，其中一个使用默认 provider，另一个使用 aws.prod。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "dev" {
#   bucket = "tf-pro-lab-100-dev"
# }
#
# resource "aws_s3_bucket" "prod" {
#   provider = aws.prod
#   bucket   = "tf-pro-lab-100-prod"
# }
#
# output "bucket_names" {
#   value = [aws_s3_bucket.dev.bucket, aws_s3_bucket.prod.bucket]
# }
