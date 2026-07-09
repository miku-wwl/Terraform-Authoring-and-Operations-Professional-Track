# Module database 知识点总结：
# - 这个子模块接管原来 root module 中的 DynamoDB table。
# - moved block 写在 root module 中，但 to 地址会指向这里的 module.database.aws_dynamodb_table.platform。
# - 子模块通过 output 暴露 table_name，供 root module 继续引用。
# - DynamoDB table 必须至少定义 hash_key 和对应 attribute。
# - PAY_PER_REQUEST 是按请求计费模式，练习里不用配置读写容量。

resource "aws_dynamodb_table" "platform" {
  name         = "tf-pro-lab-105-platform"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.platform.name
}
