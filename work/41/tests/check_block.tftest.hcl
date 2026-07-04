run "check_block_validates_url_contract" {
  command = apply

  assert {
    condition     = startswith(output.service_url, "https://")
    error_message = "服务地址必须使用 https。"
  }

  assert {
    condition     = output.service_url_contract_ok == true
    error_message = "服务 URL 合约检查结果必须为 true。"
  }
}
