run "localstack_bucket_policy_is_understood" {
  command = apply
  assert {
    condition     = output.bucket_policy_relationship.policy_bucket == aws_s3_bucket.logs.id && output.bucket_policy_relationship.bucket_arn == aws_s3_bucket.logs.arn
    error_message = "Bucket Policy must bind to the Terraform-created Bucket."
  }
  assert {
    condition = output.bucket_policy_document.Statement == [
      { Sid = "AllowBucketListing", Effect = "Allow", Action = "s3:ListBucket", Resource = "arn:aws:s3:::tf-pro-lab-141-logs", Principal = { AWS = "arn:aws:iam::000000000000:root" } },
      { Sid = "AllowObjectReads", Effect = "Allow", Action = "s3:GetObject", Resource = "arn:aws:s3:::tf-pro-lab-141-logs/*", Principal = { AWS = "arn:aws:iam::000000000000:root" } }
    ]
    error_message = "Bucket and object actions must use separate correctly scoped statements."
  }
}
