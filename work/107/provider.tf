variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

provider "aws" {
  region  = "us-east-1"
  profile = "lab"
  # 让 provider 读取实验目录中的 AWS CLI config，而不是默认的 ~/.aws/config。
  shared_config_files = ["${path.module}/aws-config/config"]
  # 让 provider 读取实验目录中的 credentials，而不是默认的 ~/.aws/credentials。
  shared_credentials_files = ["${path.module}/aws-config/credentials"]

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
  }
}
