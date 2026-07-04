run "pre_and_post_conditions_pass" {
  command = apply

  assert {
    condition     = output.compute_size == "small"
    error_message = "默认规格必须通过 precondition 和 postcondition。"
  }
}

run "precondition_rejects_xlarge" {
  command = plan

  variables {
    instance_size = "xlarge"
  }

  expect_failures = [
    terraform_data.compute_request
  ]
}
