provider "aws" {
  alias                       = "audit"
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  default_tags {
    tags = {
      Course = "terraform-pro"
      Lab    = "161"
    }
  }

  endpoints {
    ec2 = var.localstack_endpoint
    iam = var.localstack_endpoint
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
  }
}

data "aws_caller_identity" "audit" {
  provider = aws.audit
}

resource "aws_s3_bucket" "audit" {
  provider = aws.audit
  bucket   = "tf-pro-161-audit"
}

output "caller_account" {
  value = data.aws_caller_identity.audit.account_id
}

output "bucket_name" {
  value = aws_s3_bucket.audit.bucket
}
