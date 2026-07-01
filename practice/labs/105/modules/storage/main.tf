resource "aws_s3_bucket" "audit" {
  bucket = "tf-pro-lab-105"
}

output "bucket_name" {
  value = aws_s3_bucket.audit.bucket
}
