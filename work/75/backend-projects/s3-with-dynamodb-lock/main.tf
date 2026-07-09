terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# 这个小项目演示：S3 backend 的 state bucket 和 DynamoDB lock table
# 可以由一个单独的 bootstrap/foundation 项目提前创建。
# 它本身不要使用这个 S3 backend；否则会变成“先用 backend，再创建 backend”的循环。

variable "localstack_endpoint" {
  description = "LocalStack endpoint used by the AWS provider."
  type        = string
  default     = "http://localhost:4566"
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    dynamodb = var.localstack_endpoint
    s3       = var.localstack_endpoint
    sts      = var.localstack_endpoint
  }
}

# S3 保存 Terraform state。
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "tf-pro-state-localstack"
  force_destroy = true
}

# DynamoDB 保存 state lock/digest 信息。
# 旧式 S3 backend locking 要求主键名必须是 LockID，类型必须是 String。
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "tf-pro-lock-localstack"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "backend_hcl_hint" {
  value = {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "labs/75/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
  }
}
