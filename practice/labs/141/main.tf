resource "aws_s3_bucket" "logs" {
  bucket = "tf-pro-lab-141-logs"
}

data "aws_iam_policy_document" "bucket_read" {
  statement {
    sid    = "AllowReadFromExamplePrincipal"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.logs.arn,
      "${aws_s3_bucket.logs.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::000000000000:root"]
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.bucket_read.json
}

output "bucket_name" {
  value = aws_s3_bucket.logs.bucket
}

output "bucket_policy" {
  value = data.aws_iam_policy_document.bucket_read.json
}
