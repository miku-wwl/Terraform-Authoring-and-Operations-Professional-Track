terraform {
  required_version = ">= 1.12.0"
}

# TODO: 使用 data "terraform_remote_state" "network" 读取 network state。
# TODO: 创建一个 terraform_data 资源，使用 remote state 中的 public_cidr。
