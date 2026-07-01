resource "aws_s3_bucket" "assumed" {
  bucket = "tf-pro-lab-113"
}

output "bucket_name" {
  value = aws_s3_bucket.assumed.bucket
}
