# Lab 111 知识点总结：
# - 本实验的核心在 provider.tf：给 AWS Provider 配置 default_tags。
# - AWS Provider 的 default_tags 会给该 provider 管理的资源自动附加统一标签。
# - resource 自己的 tags 会和 provider default_tags 合并。
# - 如果 resource tags 与 default_tags 使用同一个 key，resource 级别的值会覆盖默认值。
# - tags 表示资源显式声明的标签；tags_all 表示合并 provider default_tags 后的最终标签。
# - default_tags 常用于统一 ManagedBy、Environment、CostCenter、Team 等治理标签。

# TODO: 先在 provider.tf 中补 default_tags，再创建两个 S3 bucket 验证继承和覆盖。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "aws_s3_bucket" "default" {
#   bucket = "tf-pro-lab-111-a"
# }
#
# resource "aws_s3_bucket" "override" {
#   bucket = "tf-pro-lab-111-b"
#
#   tags = {
#     Team = "network"
#   }
# }
#
# output "default_tags" {
#   value = aws_s3_bucket.default.tags_all
# }
#
# output "override_tags" {
#   value = aws_s3_bucket.override.tags_all
# }
