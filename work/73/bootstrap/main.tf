terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54"
    }
  }
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
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-lab73"
}

output "state_bucket_name" {
  description = "LocalStack S3 bucket that stores the lab73 Terraform state."
  value       = aws_s3_bucket.terraform_state.bucket
}
