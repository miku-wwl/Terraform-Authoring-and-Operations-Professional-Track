run "json_encode_and_decode_work" {
  command = plan

  assert {
    condition     = strcontains(output.encoded_service, "\"payments\"")
    error_message = "jsonencode 输出必须包含服务名。"
  }

  assert {
    condition     = output.decoded_service_name == "payments"
    error_message = "jsondecode 必须能读取外部 JSON 中的 name。"
  }

  assert {
    condition     = output.decoded_skill_count == 3
    error_message = "jsondecode 必须保留数组长度。"
  }
}
