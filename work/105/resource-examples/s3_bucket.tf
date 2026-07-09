# S3 bucket：只负责 bucket 本体。
resource "aws_s3_bucket" "example" {
  bucket        = "example-audit-bucket" # bucket 名称；真实 AWS 中需要全局唯一。
  force_destroy = false                  # true 时 destroy 会连 bucket 内对象一起删除，生产慎用。

  tags = {
    Project = "tf-lab-105" # 项目标签。
    Managed = "terraform"  # 标记由 Terraform 管理。
  }
}

# 阻止公开访问：真实项目里通常建议开启。
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id # 关联上面的 bucket。

  block_public_acls       = true # 阻止公开 ACL。
  block_public_policy     = true # 阻止公开 bucket policy。
  ignore_public_acls      = true # 忽略已有公开 ACL。
  restrict_public_buckets = true # 限制公开 bucket。
}

# 版本控制：保留对象历史版本。
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id # 关联上面的 bucket。

  versioning_configuration {
    status = "Enabled" # Enabled 开启；Suspended 暂停。
  }
}

# 服务端加密：对象写入时自动加密。
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id # 关联上面的 bucket。

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # 使用 S3 托管密钥加密。
    }
  }
}

