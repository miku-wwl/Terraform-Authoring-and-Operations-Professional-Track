variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
  validation {
    condition     = var.localstack_endpoint == "http://localhost:4566"
    error_message = "Lab 140 only permits LocalStack localhost:4566."
  }
}

provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  # 只配置 EC2；本实验不会调用不受支持的 Auto Scaling API。
  endpoints { ec2 = var.localstack_endpoint }
}
