terraform {
  required_version = ">= 1.12.0"
}

# Lab 79 network 知识点总结：
# - network 配置代表上游团队，负责产出并维护网络相关输出。
# - output 是跨配置共享的契约；下游只能读取这里明确暴露的 public_cidr 和 network_owner。
# - 本实验把 network state 写入 labs/79/network/terraform.tfstate。
# - 下游 security 配置会基于这些 outputs 生成自己的安全规则说明，不要手工复制值。

# TODO: 创建 network 团队的 terraform_data 资源，并输出 security 团队需要消费的 public_cidr 与 network_owner。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "terraform_data" "network" {
#   input = {
#     lab         = "79"
#     public_cidr = "203.0.113.79/32"
#     owner       = "network-team"
#     purpose     = "shared-security-input"
#   }
# }
#
# output "public_cidr" {
#   value = terraform_data.network.output.public_cidr
# }
#
# output "network_owner" {
#   value = terraform_data.network.output.owner
# }
