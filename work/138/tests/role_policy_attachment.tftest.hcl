run "localstack_role_policy_attachment_is_understood" {
  command = apply

  assert {
    condition = output.attachment_relationship == {
      role_name             = "tf-pro-lab-138-lambda-role"
      managed_policy_arn    = aws_iam_policy.logs.arn
      attachment_role       = "tf-pro-lab-138-lambda-role"
      attachment_policy_arn = aws_iam_policy.logs.arn
    }
    error_message = "Attachment must connect the expected Role name to the generated managed Policy ARN."
  }

  assert {
    condition     = output.trust_service == "lambda.amazonaws.com"
    error_message = "The Role trust policy must remain separate and trust Lambda."
  }

  assert {
    condition = output.permissions_document.Statement == [{
      Sid      = "CreateLogGroup"
      Effect   = "Allow"
      Action   = ["logs:CreateLogGroup"]
      Resource = ["*"]
    }]
    error_message = "Attached managed policy must allow logs:CreateLogGroup."
  }
}
