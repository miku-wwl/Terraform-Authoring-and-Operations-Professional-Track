variable "aws_region" {
  type        = string
  description = "AWS region used by LocalStack."
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  type        = string
  description = "LocalStack edge endpoint; only the local sandbox is accepted."
  default     = "http://localhost:4566"
  validation {
    condition     = var.localstack_endpoint == "http://localhost:4566"
    error_message = "Lab 139 only permits http://localhost:4566."
  }
}

provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints { ec2 = var.localstack_endpoint }
}
