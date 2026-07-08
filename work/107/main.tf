# Lab 107 知识点总结：
# - 本实验让 Terraform AWS Provider 直接读取指定路径的 AWS shared config/credentials 文件。
# - provider 中的 profile = "lab" 会去 shared files 中查找 lab profile。
# - shared_config_files 指向保存 region/output 等配置的 config 文件。
# - shared_credentials_files 指向保存 access key/secret key 的 credentials 文件。
# - 和 Lab 106 不同：这里不是只用 AWS CLI 读取 profile，而是让 Terraform provider 读取 profile。

# TODO: 使用指定 shared files 的 provider 创建一个 S3 bucket。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "shared_files" {
#   bucket = "tf-pro-lab-107"
# }
#
# output "bucket_name" {
#   value = aws_s3_bucket.shared_files.bucket
# }
