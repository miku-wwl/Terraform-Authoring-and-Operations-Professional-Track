terraform {
  required_version = ">= 1.5.0"
}

moved {
  from = terraform_data.database_firewall
  to   = terraform_data.payment_database_firewall
}

resource "terraform_data" "payment_database_firewall" {
  input = {
    name        = "payment-database-firewall"
    description = "通过 moved block 保留状态地址迁移意图"
  }
}

output "moved_from" {
  value = "TODO：补充旧资源地址"
}

output "moved_to" {
  value = "TODO：补充新资源地址"
}

output "firewall_name" {
  value = terraform_data.payment_database_firewall.output.name
}
