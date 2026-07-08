terraform {
  required_version = ">= 1.12.0"
}

# Lab 79 consumer 知识点总结：
# - consumer 配置代表下游安全团队，读取 network 团队的 remote state outputs。
# - terraform_remote_state 只读取对方显式 output 的值，不会把对方资源纳入当前 state 管理。
# - config 中的 key 必须指向 network 的 state：labs/79/network/terraform.tfstate。
# - 下游资源可以引用 data.terraform_remote_state.network.outputs.<NAME> 来消费上游输出。
# - 这种跨配置依赖要求先 apply 上游 network，再 apply 下游 consumer。

# TODO: 使用 data "terraform_remote_state" "network" 读取 network state。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# data "terraform_remote_state" "network" {
#   backend = "s3"
#
#   config = {
#     bucket                      = "tf-pro-state-localstack"
#     key                         = "labs/79/network/terraform.tfstate"
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
#     lab          = "79"
#     allowed_cidr = data.terraform_remote_state.network.outputs.public_cidr
#     source_owner = data.terraform_remote_state.network.outputs.network_owner
#     managed_by   = "security-team"
#   }
# }
#
# output "allowed_cidr_from_remote_state" {
#   value = terraform_data.security_rule.output.allowed_cidr
# }
