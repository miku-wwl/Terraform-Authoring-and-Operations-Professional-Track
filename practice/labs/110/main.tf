resource "aws_s3_bucket" "singapore" {
  bucket = "tf-pro-lab-110-a"
}

resource "aws_s3_bucket" "usa" {
  provider = aws.usa
  bucket   = "tf-pro-lab-110-b"
}

output "bucket_names" {
  value = [aws_s3_bucket.singapore.bucket, aws_s3_bucket.usa.bucket]
}
