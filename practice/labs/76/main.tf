terraform {
  required_version = ">= 1.12.0"
}

resource "terraform_data" "lock_table_marker" {
  input = {
    lab   = "76"
    topic = "S3 Backend 与 DynamoDB 锁"
  }
}
