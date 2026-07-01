resource "aws_s3_bucket" "dev" {
  bucket = "tf-pro-lab-100-dev"
}

resource "aws_s3_bucket" "prod" {
  provider = aws.prod
  bucket   = "tf-pro-lab-100-prod"
}

output "bucket_names" {
  value = [aws_s3_bucket.dev.bucket, aws_s3_bucket.prod.bucket]
}
