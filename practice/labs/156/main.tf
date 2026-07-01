resource "aws_s3_bucket" "challenge" {
  bucket = "tf-pro-156-artifacts"
}

resource "aws_s3_object" "report" {
  bucket  = aws_s3_bucket.challenge.bucket
  key     = "reports/challenge-one.txt"
  content = "challenge one completed with S3 object"
}

output "bucket_name" {
  value = aws_s3_bucket.challenge.bucket
}

output "object_key" {
  value = aws_s3_object.report.key
}
