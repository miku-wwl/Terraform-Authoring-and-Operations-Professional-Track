locals {
  s3_buckets = ["tf-pro-155-a", "tf-pro-155-b"]
  iam_users  = ["tf-pro-155-app", "tf-pro-155-platform"]
  sg_id      = "sg-localstack-training"
  rule_id    = "sgr-localstack-training"
}

resource "local_file" "s3" {
  filename = "artifacts/s3.txt"
  content  = join("\n", local.s3_buckets)
}

resource "local_file" "iam" {
  filename = "artifacts/iam-user.txt"
  content  = join("\n", local.iam_users)
}

resource "local_file" "sg_combined" {
  filename = "artifacts/sg-combined.txt"
  content  = "${local.sg_id}\n${local.rule_id}\n"
}

output "artifact_files" {
  value = [local_file.s3.filename, local_file.iam.filename, local_file.sg_combined.filename]
}
