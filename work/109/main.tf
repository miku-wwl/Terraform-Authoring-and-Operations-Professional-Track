# Lab 109 知识点总结：
# - 本实验让 Terraform AWS Provider 使用 named profile 创建资源。
# - provider 中的 profile = "audit" 会从 shared config/credentials 文件里读取 audit profile。
# - named profile 把凭证来源从 Terraform 配置中移出去，provider 只声明“用哪个 profile”。
# - 和 Lab107 不同：Lab107 重点是 shared files 路径；Lab109 重点是多个 profile 里选哪一个。
# - 本实验故意让 lab profile 使用 us-east-1，让 audit profile 使用 us-west-2。
# - provider.tf 不写 region，Terraform 会从 audit profile 读出 us-west-2。
# - 本实验仍然使用 LocalStack 的测试凭证，不访问真实 AWS。

# TODO: 使用 provider 的 audit profile 创建一个 S3 bucket，并输出 provider 当前 region。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "aws_region" "current" {}
#
# resource "aws_s3_bucket" "profile" {
#   bucket = "tf-pro-lab-109"
# }
#
# output "profile_summary" {
#   value = {
#     selected_profile = "audit"
#     provider_region  = data.aws_region.current.name
#     bucket_name      = aws_s3_bucket.profile.bucket
#   }
# }
