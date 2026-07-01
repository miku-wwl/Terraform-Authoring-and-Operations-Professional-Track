resource "aws_iam_user" "reader" {
  name = "tf-pro-lab-135-reader"
}

resource "aws_iam_policy" "s3_read" {
  name        = "tf-pro-lab-135-s3-read"
  description = "允许读取 S3 bucket 列表和对象的练习策略"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "reader" {
  user       = aws_iam_user.reader.name
  policy_arn = aws_iam_policy.s3_read.arn
}

output "reader_name" {
  value = aws_iam_user.reader.name
}

output "policy_arn" {
  value = aws_iam_policy.s3_read.arn
}
