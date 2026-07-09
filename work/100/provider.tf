variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

# Lab 100 provider.tf 知识点总结：
# - 一个 Terraform 配置可以有多个同类型 provider 配置。
# - 没有 alias 的 provider 是默认 provider，资源默认使用它。
# - 带 alias 的 provider 是另一个 provider 实例，例如 aws.prod。
# - alias 常用于不同 region、不同账号、不同 assume_role 或不同 endpoint。
# - LocalStack lab 里两个 provider 都指向同一个本地 endpoint，只用不同 region 模拟多 provider 场景。

# TODO: 定义默认 AWS provider。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# provider "aws" {
#   region                      = "us-east-1"
#   access_key                  = "test"
#   secret_key                  = "test"
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true
#   s3_use_path_style           = true
#
#   endpoints {
#     s3  = var.localstack_endpoint
#     sts = var.localstack_endpoint
#   }
# }

# TODO: 定义 alias provider：aws.prod。
# Hint：和默认 provider 很像，但必须多写 alias = "prod"。
#
# provider "aws" {
#   alias                       = "prod"
#   region                      = "ap-southeast-2"
#   access_key                  = "test"
#   secret_key                  = "test"
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true
#   s3_use_path_style           = true
#
#   endpoints {
#     s3  = var.localstack_endpoint
#     sts = var.localstack_endpoint
#   }
# }
