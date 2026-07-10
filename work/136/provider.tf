variable "aws_region" {
  type        = string
  description = "AWS region interpolated into the lab policy and used by the LocalStack provider."
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  type        = string
  description = "LocalStack edge endpoint. This lab intentionally accepts only the local sandbox address."
  default     = "http://localhost:4566"

  validation {
    condition     = var.localstack_endpoint == "http://localhost:4566"
    error_message = "Lab 136 only permits http://localhost:4566 so it cannot accidentally manage real AWS IAM."
  }
}

# test/test 凭据由 bootstrap 脚本在当前 shell 中提供；不要把真实 credentials 写入 provider。
provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Policy 中的 logs Action 只是 JSON 内容；本 Lab 实际只调用 IAM API 创建 managed policy。
  endpoints {
    iam = var.localstack_endpoint
  }
}
