resource "aws_s3_bucket" "default" {
  bucket = "tf-pro-lab-111-a"
}

resource "aws_s3_bucket" "override" {
  bucket = "tf-pro-lab-111-b"
  tags = {
    Team = "network"
  }
}

output "default_tags" {
  value = aws_s3_bucket.default.tags_all
}

output "override_tags" {
  value = aws_s3_bucket.override.tags_all
}
