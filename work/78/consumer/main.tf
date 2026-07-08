terraform {
  required_version = ">= 1.12.0"
}

# Lab 78 consumer 知识点总结：
# - terraform_remote_state 是 Terraform 内置 data source，用来读取另一个配置写入 backend 的 outputs。
# - 它读取的是对方 state 中的 output 值，不会读取对方所有资源细节。
# - consumer 必须知道 network state 的 backend 类型和位置，例如 S3 bucket、key、region 和 endpoint。
# - 依赖 remote state 时，要先 apply 上游 network，再 apply 下游 consumer。
# - 这种方式常用于跨团队共享基础设施信息，但会形成 state 级依赖，输出字段要保持稳定。

# TODO: 使用 data "terraform_remote_state" "network" 读取 network state。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "terraform_remote_state" "network" {
#   backend = "s3"
#
#   config = {
#     bucket                      = "tf-pro-state-localstack"
#     key                         = "labs/78/network/terraform.tfstate"
#     region                      = "us-east-1"
#     access_key                  = "test"
#     secret_key                  = "test"
#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     skip_region_validation      = true
#     skip_requesting_account_id  = true
#     use_path_style              = true
#     endpoints = {
#       s3       = "http://localhost:4566"
#       dynamodb = "http://localhost:4566"
#     }
#   }
# }
#
# TODO: 创建一个 terraform_data 资源，使用 remote state 中的 public_cidr。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "terraform_data" "security_rule" {
#   input = {
#     lab          = "78"
#     allowed_cidr = data.terraform_remote_state.network.outputs.public_cidr
#     source_owner = data.terraform_remote_state.network.outputs.network_owner
#     managed_by   = "security-team"
#   }
# }
#
# output "allowed_cidr_from_remote_state" {
#   value = terraform_data.security_rule.output.allowed_cidr
# }
