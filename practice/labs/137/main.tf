data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name               = "tf-pro-lab-137-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

output "role_name" {
  value = aws_iam_role.ec2.name
}

output "role_arn" {
  value = aws_iam_role.ec2.arn
}
