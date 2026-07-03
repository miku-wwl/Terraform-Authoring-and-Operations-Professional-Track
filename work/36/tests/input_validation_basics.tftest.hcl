run "valid_inputs_pass" {
  command = apply

  assert {
    condition     = output.workspace_name == "team-dev-01"
    error_message = "合法工作区名称必须通过验证。"
  }

  assert {
    condition     = output.environment == "dev"
    error_message = "合法 environment 必须通过验证。"
  }

  assert {
    condition     = output.instance_count == 3
    error_message = "合法 instance_count 必须通过验证。"
  }
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

run "invalid_instance_count_rejected" {
  command = plan

  variables {
    instance_count = 100
  }

  expect_failures = [
    var.instance_count
  ]
}
