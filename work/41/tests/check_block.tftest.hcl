run "check_block_validates_url_contract" {
  command = apply

  assert {
    condition     = startswith(output.service_url, "https://")
    error_message = "服务地址必须使用 https。"
  }
}
