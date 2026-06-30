run "moved_block_addresses_are_recorded" {
  command = plan

  assert {
    condition     = output.moved_from == "terraform_data.database_firewall"
    error_message = "必须记录 moved block 的旧地址。"
  }

  assert {
    condition     = output.moved_to == "terraform_data.payment_database_firewall"
    error_message = "必须记录 moved block 的新地址。"
  }
}
