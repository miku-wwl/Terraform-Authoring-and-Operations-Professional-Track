# Module buckets 知识点总结：
# - 子模块通过变量接收要创建的 S3 bucket 数量。
# - count 会把一个 resource 扩展成多个实例，地址形如 aws_s3_bucket.this[0]。
# - count.index 可用于生成每个实例唯一的 bucket 名称。
# - splat 表达式 aws_s3_bucket.this[*].bucket 可以收集所有实例的 bucket 名称。

# resource "aws_s3_bucket" "this" {
#   bucket = "tf-pro-lab-104-bucket-1"
# }

# output "bucket_names" {
#   value = [aws_s3_bucket.this.bucket]
# }

variable "bucket_count" {
  type = number
}

resource "aws_s3_bucket" "this" {
  count  = var.bucket_count
  bucket = "tf-pro-lab-104-bucket-${count.index}"
}

output "bucket_names" {
  value = aws_s3_bucket.this[*].bucket
}
