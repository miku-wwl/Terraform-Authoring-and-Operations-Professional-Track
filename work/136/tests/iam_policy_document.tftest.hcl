run "localstack_iam_policy_document_is_understood" {
  command = apply

  assert {
    condition = output.policy_summary == {
      name            = "tf-pro-lab-136-read-logs"
      arn             = aws_iam_policy.read_logs.arn
      version         = "2012-10-17"
      statement_count = 2
    }
    error_message = "Policy summary must identify the managed policy and the two-statement document."
  }

  assert {
    condition = output.policy_document.Statement == [
      {
        Sid      = "DescribeLogGroups"
        Effect   = "Allow"
        Action   = "logs:DescribeLogGroups"
        Resource = "*"
      },
      {
        Sid      = "ReadLogStream"
        Effect   = "Allow"
        Action   = "logs:GetLogEvents"
        Resource = "arn:aws:logs:us-east-1:*:log-group:/aws/lambda/tf-pro-lab-136:log-stream:*"
      }
    ]
    error_message = "Generated JSON must contain the default Allow and correctly scoped Logs statements."
  }

  assert {
    condition     = jsondecode(output.policy_json) == output.policy_document
    error_message = "policy_json must represent the same semantics as policy_document."
  }
}
