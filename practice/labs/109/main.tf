resource "aws_s3_bucket" "profile" {
  bucket = "tf-pro-lab-109"
}

output "bucket_name" {
  value = aws_s3_bucket.profile.bucket
}
