# Lab 100 知识点总结：
# - provider alias 用来在同一个配置中定义同类型 provider 的多个实例，例如默认 aws 和 aws.prod。
# - 子模块不会自动拿到所有 alias provider；root module 需要通过 module 的 providers map 显式传入。
# - providers map 左侧是子模块看到的 provider 名称，右侧是 root module 中的 provider 配置。
# - aws = aws 表示把默认 AWS provider 传给子模块；aws.prod = aws.prod 表示把 alias provider 传给子模块。
# - 子模块如果要接收 aws.prod，必须在 required_providers 中声明 configuration_aliases = [aws.prod]。

# TODO: 调用 modules/buckets，并通过 providers map 传入默认 provider 与 aws.prod。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# module "buckets" {
#   source = "./modules/buckets"
#
#   providers = {
#     aws      = aws
#     aws.prod = aws.prod
#   }
# }
#
# output "bucket_names" {
#   value = module.buckets.bucket_names
# }
