variable "aws_region" {
  type        = string
  description = "AWS region used by the LocalStack provider."
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  type        = string
  description = "LocalStack edge endpoint. This lab accepts only the local sandbox address."
  default     = "http://localhost:4566"

  validation {
    condition     = var.localstack_endpoint == "http://localhost:4566"
    error_message = "Lab 138 only permits http://localhost:4566 so it cannot manage real AWS IAM."
  }
}

# test/test 凭据由 bootstrap 脚本提供；不要把真实 credentials 写入 provider。
provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Role、Policy 与 Attachment 都只调用 IAM API。
  endpoints {
    iam = var.localstack_endpoint
  }
}
