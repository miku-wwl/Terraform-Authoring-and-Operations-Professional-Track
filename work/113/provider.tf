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
    # assume_role 需要 STS，本实验通过 LocalStack 模拟 STS。
    sts = var.localstack_endpoint
    iam = var.localstack_endpoint
  }

  assume_role {
    # 真实 AWS 中这里通常是目标角色 ARN；本实验使用 LocalStack 模拟 ARN。
    role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-113"
    session_name = "tf-pro-lab-113"
  }
}
