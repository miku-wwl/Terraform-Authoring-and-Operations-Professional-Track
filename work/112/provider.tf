variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3 = var.localstack_endpoint
    # assume_role 需要通过 STS 完成临时身份获取，本实验用 LocalStack 模拟 STS。
    sts = var.localstack_endpoint
    iam = var.localstack_endpoint
  }

  # TODO: 在 provider 中配置 assume_role。
  # Hint：把下面这段取消注释即可。
  #
  # assume_role {
  #   # 真实 AWS 中这里通常是目标账号/目标角色 ARN；本实验使用 LocalStack 模拟 ARN。
  #   role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-112"
  #   session_name = "tf-pro-lab-112"
  # }
}
