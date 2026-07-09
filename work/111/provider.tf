variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
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
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
  }

  default_tags {
    # 这些标签会自动合并到该 provider 管理的 AWS 资源上。
    tags = {
      ManagedBy   = "Terraform"
      Environment = "lab"
      Team        = "platform"
    }
  }
}
