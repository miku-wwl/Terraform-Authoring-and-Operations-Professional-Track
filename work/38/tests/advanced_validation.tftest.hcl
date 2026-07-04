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

run "invalid_size_rejected" {
  command = plan

  variables {
    instance_size = "huge"
  }

  expect_failures = [
    var.instance_size
  ]
}

run "invalid_environment_rejected" {
  command = plan

  variables {
    environment = "production"
  }

  expect_failures = [
    var.environment
  ]
}
