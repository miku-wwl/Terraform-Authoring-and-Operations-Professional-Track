resource "aws_s3_bucket" "renamed" {
  count  = 2
  bucket = "tf-pro-lab-101-${count.index}"
}

moved {
  from = aws_s3_bucket.original
  to   = aws_s3_bucket.renamed
}

output "bucket_names" {
  value = aws_s3_bucket.renamed[*].bucket
}
