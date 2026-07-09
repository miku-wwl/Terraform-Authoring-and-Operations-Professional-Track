terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# 这个小项目演示：Lab77 查看远端 state 前，需要先有一个保存 state 的 S3 bucket。
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
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
  }
}

# S3 保存 Terraform remote state。
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "tf-pro-state-localstack"
  force_destroy = true
}

output "backend_hcl_hint" {
  value = {
    bucket = aws_s3_bucket.terraform_state.bucket
    key    = "labs/77/terraform.tfstate"
    region = "us-east-1"
  }
}
