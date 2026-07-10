run "localstack_ec2_role_trust_is_understood" {
  command = apply

  assert {
    condition = output.role_identity == {
      name = "tf-pro-lab-137-ec2-role"
      arn  = aws_iam_role.ec2.arn
    }
    error_message = "Role identity must contain the expected name and generated ARN."
  }

  assert {
    condition = output.trust_policy_document == {
      Version = "2012-10-17"
      Statement = [{
        Sid       = "AllowEC2AssumeRole"
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = { Service = "ec2.amazonaws.com" }
      }]
    }
    error_message = "Role trust policy must allow only the EC2 service principal to call sts:AssumeRole."
  }
}
