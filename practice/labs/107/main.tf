resource "aws_s3_bucket" "shared_files" {
  bucket = "tf-pro-lab-107"
}

output "bucket_name" {
  value = aws_s3_bucket.shared_files.bucket
}
