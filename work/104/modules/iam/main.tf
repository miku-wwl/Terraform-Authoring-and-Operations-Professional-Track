# Module iam 知识点总结：
# - 子模块通过变量接收要创建的 IAM user 数量。
# - count 会把一个 resource 扩展成多个实例，地址形如 aws_iam_user.this[0]。
# - count.index 可用于生成每个实例唯一的名称。
# - splat 表达式 aws_iam_user.this[*].name 可以收集所有实例的 name。

# TODO: 创建支持 count 的 IAM user 模块。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# variable "user_count" {
#   type = number
# }
#
# resource "aws_iam_user" "this" {
#   count = var.user_count
#   name  = "tf-pro-lab-104-user-${count.index}"
# }
#
# output "user_names" {
#   value = aws_iam_user.this[*].name
# }
