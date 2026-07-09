# Lab 105 知识点总结：
# - 本实验练习把 root module 中已有的资源拆分到 child module 中。
# - 资源移入子模块后，state 地址会从 aws_dynamodb_table.platform 变成 module.database.aws_dynamodb_table.platform。
# - moved block 可以把 root 资源地址迁移到 module 资源地址，避免销毁重建。
# - 拆分多个模块时，每个被移动的资源都需要单独写 moved block。
# - root module 可以通过 module.<NAME>.<OUTPUT_NAME> 继续读取子模块输出。
# - 这类重构的验收重点是 state 地址进入 module，且 plan 不出现非预期 destroy/create。

# resource "aws_dynamodb_table" "platform" {
#   name         = "tf-pro-lab-105-platform"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"

#   attribute {
#     name = "id"
#     type = "S"
#   }
# }

# resource "aws_s3_bucket" "audit" {
#   bucket = "tf-pro-lab-105-audit"
# }

# output "root_resources" {
#   value = {
#     table  = aws_dynamodb_table.platform.name
#     bucket = aws_s3_bucket.audit.bucket
#   }
# }

# 做题流程：
# 1. 先保留上面的旧 root 资源，执行 terraform init / apply。
# 2. 执行 terraform state list，观察旧地址：
#    aws_dynamodb_table.platform
#    aws_s3_bucket.audit
# 3. 然后把上面的 root resource/output 注释掉。
# 4. 把下面的 module/moved/output 取消注释。
# 5. 再执行 terraform plan，确认资源地址进入 module，且没有非预期 destroy/create。

module "database" {
  source = "./modules/database"
}

module "storage" {
  source = "./modules/storage"
}

moved {
  from = aws_dynamodb_table.platform
  to   = module.database.aws_dynamodb_table.platform
}

moved {
  from = aws_s3_bucket.audit
  to   = module.storage.aws_s3_bucket.audit
}

output "module_resources" {
  value = {
    table  = module.database.table_name
    bucket = module.storage.bucket_name
  }
}
