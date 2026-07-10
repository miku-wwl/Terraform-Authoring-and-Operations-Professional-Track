variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

# 默认 provider：代表发起 AssumeRole 的基础身份。
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
    iam = var.localstack_endpoint
  }
}

# TODO: 定义 aws.assumed provider，让它扮演 bootstrap 创建的 IAM Role。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# provider "aws" {
#   alias                       = "assumed"
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
#     iam = var.localstack_endpoint
#   }
#
#   assume_role {
#     role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-113"
#     session_name = "tf-pro-lab-113-session"
#   }
# }
