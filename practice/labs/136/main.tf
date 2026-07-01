data "aws_iam_policy_document" "read_logs" {
  statement {
    sid    = "ReadLogs"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
      "logs:GetLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "read_logs" {
  name   = "tf-pro-lab-136-read-logs"
  policy = data.aws_iam_policy_document.read_logs.json
}

output "policy_json" {
  value = data.aws_iam_policy_document.read_logs.json
}

output "policy_arn" {
  value = aws_iam_policy.read_logs.arn
}
