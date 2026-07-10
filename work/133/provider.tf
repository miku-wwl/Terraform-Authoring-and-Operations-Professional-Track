variable "aws_region" {
  type        = string
  description = "AWS region used by the LocalStack provider configuration."
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  type        = string
  description = "LocalStack edge endpoint. This lab intentionally accepts only the local sandbox address."
  default     = "http://localhost:4566"

  validation {
    condition     = var.localstack_endpoint == "http://localhost:4566"
    error_message = "Lab 133 only permits http://localhost:4566 so it cannot accidentally manage real AWS."
  }
}

# 凭据由 bootstrap 脚本通过环境变量提供。
# test/test 只是 LocalStack 测试值，不要把真实 AWS credentials 写进 provider block。
provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # 本 Lab 只创建和查询 VPC/subnet，因此只需要 EC2 endpoint。
  endpoints {
    ec2 = var.localstack_endpoint
  }
}
