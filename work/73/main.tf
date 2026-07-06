terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54"
    }
  }

  backend "s3" {
    # TODO 1: Store this lab's Terraform state in the LocalStack S3 state bucket.
    # Hint: bootstrap/ creates a bucket named tfstate-lab73.
    bucket = ""

    # TODO 2: Store the state object under lab73/terraform.tfstate.
    key = ""

    # TODO 3: Use us-east-1 and point the S3 backend at LocalStack.
    region = ""

    # TODO 4: Configure local test credentials and LocalStack-compatible S3 backend flags.
    # Hint: endpoint is http://localhost:4566 and path-style access must be enabled.
    endpoint                    = ""
    access_key                  = ""
    secret_key                  = ""
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

provider "aws" {
  # TODO 5: Configure the AWS provider to talk to LocalStack S3.
  region                      = ""
  access_key                  = ""
  secret_key                  = ""
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3 = ""
  }
}

locals {
  # TODO 6: Record the backend settings used above so tests and outputs can audit them.
  localstack_endpoint = ""
  backend_region      = ""
  state_bucket_name   = ""
  state_key           = ""

  # TODO 7: Name an application bucket and explain what this lab proves.
  application_bucket_name = ""
  backend_lesson_summary = {
    backend_type      = ""
    state_location    = ""
    provider_endpoint = local.localstack_endpoint
    lesson            = ""
  }
}

resource "aws_s3_bucket" "application" {
  bucket = local.application_bucket_name
}

resource "aws_s3_object" "backend_note" {
  bucket  = aws_s3_bucket.application.id
  key     = "backend/remote-state.txt"
  content = "lab73 stores Terraform state in a LocalStack S3 backend."
}

output "localstack_endpoint" {
  description = "LocalStack endpoint used by the AWS provider and S3 backend."
  value       = local.localstack_endpoint
}

output "backend_region" {
  description = "AWS region used by the LocalStack S3 backend."
  value       = local.backend_region
}

output "state_bucket_name" {
  description = "S3 bucket name used by the Terraform backend."
  value       = local.state_bucket_name
}

output "state_key" {
  description = "S3 object key used by the Terraform backend state file."
  value       = local.state_key
}

output "application_bucket_name" {
  description = "S3 bucket managed by this lab after the remote backend is initialized."
  value       = aws_s3_bucket.application.bucket
}

output "backend_note_object_key" {
  description = "S3 object key created to prove the provider is using LocalStack."
  value       = aws_s3_object.backend_note.key
}

output "backend_lesson_summary" {
  description = "Summary of the LocalStack S3 backend lesson."
  value       = local.backend_lesson_summary
}
