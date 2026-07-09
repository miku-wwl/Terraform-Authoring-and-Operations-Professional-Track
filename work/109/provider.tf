variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

provider "aws" {
  # Lab109 的重点是 profile 选择：这里故意使用 audit，而不是 lab。
  # region 不在 provider 中写死，而是从 audit profile 的 config 里读取。
  profile = "audit"
  # 指向实验目录中的 AWS CLI config。
  shared_config_files = ["${path.module}/aws-config/config"]
  # 指向实验目录中的 credentials。
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
