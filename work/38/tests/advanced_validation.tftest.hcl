run "allowed_values_are_enforced" {
  command = apply

  assert {
    condition     = contains(output.validated_request.allowed_sizes, output.validated_request.instance_size)
    error_message = "实例规格必须来自允许列表。"
  }

  assert {
    condition     = output.validated_request.environment == "dev"
    error_message = "默认环境应为 dev。"
  }
}
