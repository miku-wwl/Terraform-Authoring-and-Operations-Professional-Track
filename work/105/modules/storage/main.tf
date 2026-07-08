# Module storage 知识点总结：
# - 这个子模块接管原来 root module 中的 S3 bucket。
# - moved block 写在 root module 中，但 to 地址会指向这里的 module.storage.aws_s3_bucket.audit。
# - 子模块通过 output 暴露 bucket_name，供 root module 继续引用。

# TODO: S3 子模块。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "audit" {
#   bucket = "tf-pro-lab-105"
# }
#
# output "bucket_name" {
#   value = aws_s3_bucket.audit.bucket
# }
