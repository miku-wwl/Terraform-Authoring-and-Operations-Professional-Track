terraform {
  required_version = ">= 1.12.0"
}

# Lab 78 network 知识点总结：
# - network 配置代表“上游团队”，负责把可复用信息写入自己的 remote state。
# - output 是跨配置共享信息的边界；consumer 只能通过 output 读取这里暴露的值。
# - 本实验把 public_cidr 和 network_owner 输出到 labs/78/network/terraform.tfstate。
# - 不要让下游手工复制值；让下游用 terraform_remote_state 读取这些 outputs。

resource "terraform_data" "network" {
  input = {
    lab         = "78"
    public_cidr = "203.0.113.78/32"
    owner       = "network-team"
  }
}

output "public_cidr" {
  value = terraform_data.network.output.public_cidr
}

output "network_owner" {
  value = terraform_data.network.output.owner
}
