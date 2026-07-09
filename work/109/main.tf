# Lab 109 知识点总结：
# - 本实验练习 Terraform AWS Provider 使用 named profile。
# - Lab107 重点是“provider 去哪里读文件”；Lab109 重点是“provider 选哪个 profile”。
# - provider.tf 里写 profile = "audit"，所以 provider 使用 audit profile。
# - provider.tf 不写 region 时，region 可以从 audit profile 里读取。
# - AWS_REGION / AWS_DEFAULT_REGION 环境变量会覆盖 profile 里的 region。
# - 本实验使用 LocalStack 的 test/test 假凭证，不访问真实 AWS。
#
# 先执行下面这个脚本，它会在当前目录生成 provider.tf 需要读取的两个文件：
#
#   pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
#
# 脚本生成的目录结构是：
#
#   aws-config/config
#   aws-config/credentials
#
# provider.tf 通过 shared_config_files 和 shared_credentials_files 指向这两个文件。

data "aws_region" "current" {}

resource "aws_s3_bucket" "profile" {
  bucket = "tf-pro-lab-109"
}

output "profile_summary" {
  value = {
    selected_profile = "audit"
    provider_region  = data.aws_region.current.name
    bucket_name      = aws_s3_bucket.profile.bucket
  }
}
