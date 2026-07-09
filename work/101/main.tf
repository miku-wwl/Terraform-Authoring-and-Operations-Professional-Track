# Lab 101 知识点总结：
# - moved block 用来告诉 Terraform：某个资源的 state 地址变了，但它代表的真实对象没有变。
# - 重命名资源时，如果不写 moved block，Terraform 可能计划 destroy 旧地址并 create 新地址。
# - 带 count 的资源地址包含实例索引，例如 aws_s3_bucket.original[0] 和 aws_s3_bucket.original[1]。
# - 当整个 count 资源从 original 重命名为 renamed 时，可以用 from = aws_s3_bucket.original 到 to = aws_s3_bucket.renamed。
# - moved block 只迁移 Terraform state 地址，不会修改真实云资源本身。
# - 这类重构的验收重点是 plan 中不出现非预期 destroy/create。

# 做题流程：
# 1. 先保留下面的旧代码，执行 terraform init / apply，让 state 里真的出现旧地址。
# 2. 执行 terraform state list，观察旧地址：
#    aws_s3_bucket.original[0]
#    aws_s3_bucket.original[1]
# 3. 然后把旧 resource 注释掉，改用下面 Hint 里的 renamed resource。
# 4. 同时写 moved block，把旧 state 地址迁移到新代码地址。
# 5. 最后执行 terraform plan，确认没有非预期 destroy/create。

# resource "aws_s3_bucket" "original" {
#   count  = 2
#   bucket = "tf-pro-lab-101-${count.index}"
# }

# output "bucket_names" {
#   value = aws_s3_bucket.original[*].bucket
# }

resource "aws_s3_bucket" "renamed" {
  count  = 2
  bucket = "tf-pro-lab-101-${count.index}"
}

moved {
  from = aws_s3_bucket.original
  to   = aws_s3_bucket.renamed
}

output "bucket_names" {
  value = aws_s3_bucket.renamed[*].bucket
}
