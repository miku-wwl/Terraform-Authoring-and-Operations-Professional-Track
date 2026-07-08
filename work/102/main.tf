# Lab 102 知识点总结：
# - 本实验练习把多个独立资源重构为一个带 count 的资源。
# - 启用 count 后，资源地址会从 aws_s3_bucket.a 这类无索引地址，变成 aws_s3_bucket.instances[0] 这类带索引地址。
# - moved block 可以把旧 state 地址逐个映射到新的 count 实例地址。
# - 每个旧资源都需要一个明确的 moved block，例如 a -> instances[0]、b -> instances[1]。
# - moved block 只迁移 Terraform state 地址，不会修改真实云资源本身。
# - 这类重构的验收重点是 plan 中不出现非预期 destroy/create。

# TODO: 使用课程要求的 moved block 完成重构，避免资源销毁重建。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "instances" {
#   count  = 2
#   bucket = "tf-pro-lab-102-${count.index}"
# }
#
# moved {
#   from = aws_s3_bucket.a
#   to   = aws_s3_bucket.instances[0]
# }
#
# moved {
#   from = aws_s3_bucket.b
#   to   = aws_s3_bucket.instances[1]
# }
#
# output "bucket_names" {
#   value = aws_s3_bucket.instances[*].bucket
# }
