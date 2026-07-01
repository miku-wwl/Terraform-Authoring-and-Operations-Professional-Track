locals {
  buckets = {
    app  = "tf-pro-lab-103-a"
    logs = "tf-pro-lab-103-b"
  }
}

resource "aws_s3_bucket" "instances" {
  for_each = local.buckets
  bucket   = each.value
}

moved {
  from = aws_s3_bucket.a
  to   = aws_s3_bucket.instances["app"]
}

moved {
  from = aws_s3_bucket.b
  to   = aws_s3_bucket.instances["logs"]
}

output "bucket_names" {
  value = values(aws_s3_bucket.instances)[*].bucket
}
