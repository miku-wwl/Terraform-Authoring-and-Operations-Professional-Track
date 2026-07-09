# Lab 104 知识点总结：
# - 本实验练习“模块内部资源”启用 count 后的 state 地址迁移。
# - 模块内资源的完整地址会带 module 路径，例如 module.buckets.aws_s3_bucket.this。
# - 启用 count 后，地址会变成 module.buckets.aws_s3_bucket.this[1] 这种带索引的形式。
# - moved block 可以写在 root module 中，用来迁移子模块内部资源的 state 地址。
# - from 和 to 必须写完整地址，包括 module.<NAME> 路径和 count index。
# - 这类重构的验收重点是 plan 中不出现非预期 destroy/create。

# module "buckets" {
#   source = "./modules/buckets"
# }

# output "bucket_names" {
#   value = module.buckets.bucket_names
# }

# 做题流程：
# 1. 先保留上面的旧代码，执行 terraform init / apply，让 state 里出现旧地址。
# 2. 执行 terraform state list，观察完整模块资源地址：
#    module.buckets.aws_s3_bucket.this
# 3. 然后把 root module 改成传 bucket_count = 3。
# 4. 同时把 modules/buckets/main.tf 改成 count 版本。
# 5. 最后在 root module 写 moved block，把旧地址迁移到 this[1]。

module "buckets" {
  source       = "./modules/buckets"
  bucket_count = 3
}

moved {
  from = module.buckets.aws_s3_bucket.this
  to   = module.buckets.aws_s3_bucket.this[1]
}

output "bucket_names" {
  value = module.buckets.bucket_names
}
