# Lab 101 知识点总结：
# - moved block 用来告诉 Terraform：某个资源的 state 地址变了，但它代表的真实对象没有变。
# - 重命名资源时，如果不写 moved block，Terraform 可能计划 destroy 旧地址并 create 新地址。
# - 带 count 的资源地址包含实例索引，例如 aws_s3_bucket.original[0] 和 aws_s3_bucket.original[1]。
# - 当整个 count 资源从 original 重命名为 renamed 时，可以用 from = aws_s3_bucket.original 到 to = aws_s3_bucket.renamed。
# - moved block 只迁移 Terraform state 地址，不会修改真实云资源本身。
# - 这类重构的验收重点是 plan 中不出现非预期 destroy/create。

# TODO: 使用课程要求的 moved block 完成重构，避免资源销毁重建。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "renamed" {
#   count  = 2
#   bucket = "tf-pro-lab-101-${count.index}"
# }
#
# moved {
#   from = aws_s3_bucket.original
#   to   = aws_s3_bucket.renamed
# }
#
# output "bucket_names" {
#   value = aws_s3_bucket.renamed[*].bucket
# }
