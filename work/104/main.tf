# Lab 104 知识点总结：
# - 本实验练习“模块内部资源”启用 count 后的 state 地址迁移。
# - 模块内资源的完整地址会带 module 路径，例如 module.iam_user.aws_iam_user.this。
# - 启用 count 后，地址会变成 module.iam_user.aws_iam_user.this[1] 这种带索引的形式。
# - moved block 可以写在 root module 中，用来迁移子模块内部资源的 state 地址。
# - from 和 to 必须写完整地址，包括 module.<NAME> 路径和 count index。
# - 这类重构的验收重点是 plan 中不出现非预期 destroy/create。

# TODO: 调用 modules/iam，并在 root module 写 moved block。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# module "iam_user" {
#   source     = "./modules/iam"
#   user_count = 3
# }
#
# moved {
#   from = module.iam_user.aws_iam_user.this
#   to   = module.iam_user.aws_iam_user.this[1]
# }
#
# output "user_names" {
#   value = module.iam_user.user_names
# }
