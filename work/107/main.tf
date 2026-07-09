# Lab 107 知识点总结：
# - 本实验让 Terraform AWS Provider 直接读取指定路径的 AWS shared config/credentials 文件。
# - provider 中的 profile = "lab" 会去 shared files 中查找 lab profile。
# - shared_config_files 指向保存 region/output 等配置的 config 文件。
# - shared_credentials_files 指向保存 access key/secret key 的 credentials 文件。
# - 和 Lab 106 不同：这里不是只用 AWS CLI 读取 profile，而是让 Terraform provider 读取 profile。
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
# 然后再执行 Terraform：
#
#   terraform init
#   terraform plan
#
# 如果没有先生成 aws-config，provider.tf 里的 shared_config_files 和
# shared_credentials_files 会指向不存在的文件。

resource "aws_s3_bucket" "shared_files" {
  bucket = "tf-pro-lab-107"
}

output "bucket_name" {
  value = aws_s3_bucket.shared_files.bucket
}
