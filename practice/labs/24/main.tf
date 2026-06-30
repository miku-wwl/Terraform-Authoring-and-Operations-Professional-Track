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
  value = "terraform_data.database_firewall"
}

output "moved_to" {
  value = "terraform_data.payment_database_firewall"
}

output "firewall_name" {
  value = terraform_data.payment_database_firewall.output.name
}
