resource "aws_s3_bucket" "assumed" {
  bucket = "tf-pro-lab-112"
}

output "bucket_name" {
  value = aws_s3_bucket.assumed.bucket
}
