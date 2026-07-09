# Lab 112 知识点总结：
# - assume_role 表示 provider 先用基础凭证调用 STS AssumeRole，拿到临时身份后再操作资源。
# - 真实 AWS 中常用于跨账号部署、权限边界隔离和 CI/CD 临时授权。
# - 本实验使用 LocalStack STS endpoint 模拟调用路径，不访问真实 AWS。
# - assume_role 写在 provider 中，对该 provider 管理的资源生效。
# - resource 本身不需要知道 assume role 细节，只要正常使用这个 provider 即可。

# TODO: 先在 provider.tf 中补 assume_role，再创建 S3 bucket 验证 provider 身份流。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "assumed" {
#   bucket = "tf-pro-lab-112"
# }
#
# output "bucket_name" {
#   value = aws_s3_bucket.assumed.bucket
# }
