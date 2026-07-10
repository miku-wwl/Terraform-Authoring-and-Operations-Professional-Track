run "localstack_caller_identity_is_understood" {
  command = plan

  assert {
    condition     = output.account_id == "000000000000"
    error_message = "account_id must come from the default LocalStack STS caller identity."
  }

  assert {
    condition     = length(output.caller_user_id) > 0
    error_message = "caller_user_id must contain the calling entity's unique identifier."
  }

  assert {
    condition = (
      startswith(output.caller_arn, "arn:aws:iam::000000000000:") ||
      startswith(output.caller_arn, "arn:aws:sts::000000000000:")
    )
    error_message = "caller_arn must belong to the simulated LocalStack account."
  }

  assert {
    condition     = output.example_role_arn == "arn:aws:iam::000000000000:role/platform-deployer"
    error_message = "example_role_arn must be assembled from the queried account_id."
  }

  assert {
    condition     = output.is_localstack
    error_message = "is_localstack must confirm the expected LocalStack account ID."
  }
}
