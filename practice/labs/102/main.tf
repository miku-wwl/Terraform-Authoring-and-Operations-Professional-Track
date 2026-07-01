resource "aws_s3_bucket" "instances" {
  count  = 2
  bucket = "tf-pro-lab-102-${count.index}"
}

moved {
  from = aws_s3_bucket.a
  to   = aws_s3_bucket.instances[0]
}

moved {
  from = aws_s3_bucket.b
  to   = aws_s3_bucket.instances[1]
}

output "bucket_names" {
  value = aws_s3_bucket.instances[*].bucket
}
