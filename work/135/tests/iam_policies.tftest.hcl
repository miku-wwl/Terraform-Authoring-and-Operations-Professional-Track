run "localstack_managed_and_inline_policies_are_understood" {
  command = apply

  assert {
    condition = output.policy_relationships == {
      user_name           = "tf-pro-lab-135-reader"
      managed_policy_arn  = aws_iam_policy.s3_read.arn
      attached_user       = "tf-pro-lab-135-reader"
      attached_policy_arn = aws_iam_policy.s3_read.arn
      inline_policy_name  = "tf-pro-lab-135-ec2-describe"
      inline_policy_owner = "tf-pro-lab-135-reader"
    }
    error_message = "Managed attachment and inline ownership must both target the lab reader user."
  }

  assert {
    condition = output.managed_policy_document.Statement == [
      {
        Sid      = "ListBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:aws:s3:::tf-pro-lab-135-shared"]
      },
      {
        Sid      = "ReadObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["arn:aws:s3:::tf-pro-lab-135-shared/*"]
      }
    ]
    error_message = "The managed policy must scope ListBucket to the bucket and GetObject to its objects."
  }

  assert {
    condition = output.inline_policy_document.Statement == [
      {
        Sid      = "DescribeInstances"
        Effect   = "Allow"
        Action   = ["ec2:DescribeInstances"]
        Resource = "*"
      }
    ]
    error_message = "The file-based inline policy must allow ec2:DescribeInstances."
  }
}
