# Lab 105 知识点总结：
# - 本实验练习把 root module 中已有的资源拆分到 child module 中。
# - 资源移入子模块后，state 地址会从 aws_dynamodb_table.platform 变成 module.database.aws_dynamodb_table.platform。
# - moved block 可以把 root 资源地址迁移到 module 资源地址，避免销毁重建。
# - 拆分多个模块时，每个被移动的资源都需要单独写 moved block。
# - root module 可以通过 module.<NAME>.<OUTPUT_NAME> 继续读取子模块输出。
# - 这类重构的验收重点是 state 地址进入 module，且 plan 不出现非预期 destroy/create。

# TODO: 调用 database/storage 子模块，并为旧 root 资源地址写 moved block。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# module "database" {
#   source = "./modules/database"
# }
#
# module "storage" {
#   source = "./modules/storage"
# }
#
# moved {
#   from = aws_dynamodb_table.platform
#   to   = module.database.aws_dynamodb_table.platform
# }
#
# moved {
#   from = aws_s3_bucket.audit
#   to   = module.storage.aws_s3_bucket.audit
# }
#
# output "module_resources" {
#   value = {
#     table  = module.database.table_name
#     bucket = module.storage.bucket_name
#   }
# }
