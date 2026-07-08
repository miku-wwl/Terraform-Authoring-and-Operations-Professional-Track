# Lab 103 知识点总结：
# - 本实验练习把多个独立资源重构为一个带 for_each 的资源。
# - 启用 for_each 后，资源地址会从 aws_s3_bucket.a 这类无 key 地址，变成 aws_s3_bucket.instances["app"] 这类带 key 地址。
# - for_each 的 key 是 state 地址的一部分，后续改 key 等同于改资源地址。
# - moved block 可以把旧 state 地址逐个映射到新的 for_each 实例地址。
# - 每个旧资源都需要一个明确的 moved block，例如 a -> instances["app"]、b -> instances["logs"]。
# - 这类重构的验收重点是 plan 中不出现非预期 destroy/create。

# TODO: 使用课程要求的 moved block 完成重构，避免资源销毁重建。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# locals {
#   buckets = {
#     app  = "tf-pro-lab-103-a"
#     logs = "tf-pro-lab-103-b"
#   }
# }
#
# resource "aws_s3_bucket" "instances" {
#   for_each = local.buckets
#   bucket   = each.value
# }
#
# moved {
#   from = aws_s3_bucket.a
#   to   = aws_s3_bucket.instances["app"]
# }
#
# moved {
#   from = aws_s3_bucket.b
#   to   = aws_s3_bucket.instances["logs"]
# }
#
# output "bucket_names" {
#   value = values(aws_s3_bucket.instances)[*].bucket
# }
