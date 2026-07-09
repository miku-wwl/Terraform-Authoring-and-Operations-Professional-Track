# DynamoDB 表：适合存 key-value / document 风格的数据。
resource "aws_dynamodb_table" "example" {
  name         = "example-platform-table" # 表名。
  billing_mode = "PAY_PER_REQUEST"        # 按请求计费，不需要配置读写容量。
  hash_key     = "id"                     # 分区键；必须在 attribute 里声明类型。

  attribute {
    name = "id" # 分区键字段名，要和 hash_key 一致。
    type = "S"  # 字段类型：S=String，N=Number，B=Binary。
  }

  ttl {
    attribute_name = "expires_at" # 存过期时间戳的字段名。
    enabled        = false        # 是否启用自动过期删除。
  }

  point_in_time_recovery {
    enabled = false # 是否启用时间点恢复。
  }

  tags = {
    Project = "tf-lab-105" # 项目标签。
    Managed = "terraform"  # 标记由 Terraform 管理。
  }
}

