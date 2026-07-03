terraform {
  required_version = ">= 1.5.0"
}

# TODO 1：编写 moved block，将旧地址 terraform_data.database_firewall 迁移到新地址 terraform_data.payment_database_firewall。
# 提示：moved block 声明 from 和 to，告诉 Terraform 这是一次重命名而非 destroy + create。

resource "terraform_data" "payment_database_firewall" {
  input = {
    name        = "payment-database-firewall"
    description = "通过 moved block 保留状态地址迁移意图"
  }
}

# TODO 2：补充 moved block 的旧地址（from）。
# 提示：旧地址即 moved block 中 from 的值。
output "moved_from" {
  value = "TODO：补充旧资源地址"
}

# TODO 3：补充 moved block 的新地址（to）。
# 提示：新地址即当前资源的完整地址。
output "moved_to" {
  value = "TODO：补充新资源地址"
}

output "firewall_name" {
  value = terraform_data.payment_database_firewall.output.name
}
