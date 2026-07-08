# Lab 113 知识点总结：
# - 本实验继续练习 AWS Provider assume_role 的实操路径。
# - provider 会先通过 STS AssumeRole 获取临时身份，再用该身份创建资源。
# - assume_role 写在 provider 中，对这个 provider 管理的所有资源生效。
# - 本实验使用 LocalStack 的 STS endpoint 模拟 AssumeRole，不访问真实 AWS。
# - resource 正常声明即可，不需要在资源里重复写 assume role 逻辑。

# TODO: 使用 assume_role provider 创建一个 S3 bucket。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "assumed" {
#   bucket = "tf-pro-lab-113"
# }
#
# output "bucket_name" {
#   value = aws_s3_bucket.assumed.bucket
# }
