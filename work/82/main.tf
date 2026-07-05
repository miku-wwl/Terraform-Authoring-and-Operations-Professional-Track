terraform {
  required_version = ">= 1.5.0"
}

variable "s3_bucket_name" {
  type        = string
  description = "Mock S3 bucket name used by Terraform test assertions."
  default     = "terraform-test-bucket-82"
}

locals {
  bucket_name        = var.s3_bucket_name
  bucket_name_length = length(var.s3_bucket_name)
}

resource "terraform_data" "bucket_contract" {
  input = {
    topic              = "terraform test assert blocks"
    simulated_resource = "aws_s3_bucket"
    bucket_name        = local.bucket_name
    bucket_name_length = local.bucket_name_length
  }
}

output "bucket_name" {
  description = "Mock S3 bucket name used by tests."
  value       = local.bucket_name
}

output "bucket_name_length" {
  description = "Length of the mock S3 bucket name."
  value       = local.bucket_name_length
}

output "bucket_contract" {
  description = "Terraform data resource that simulates the bucket contract."
  value       = terraform_data.bucket_contract.input
}
