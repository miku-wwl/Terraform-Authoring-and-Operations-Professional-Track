# Lab 100 知识点总结：
# - provider alias 用来在同一个配置中定义同类型 provider 的多个实例，例如默认 aws 和 aws.prod。
# - 子模块不会自动拿到所有 alias provider；root module 需要通过 module 的 providers map 显式传入。
# - providers map 左侧是子模块看到的 provider 名称，右侧是 root module 中的 provider 配置。
# - aws = aws 表示把默认 AWS provider 传给子模块；aws.prod = aws.prod 表示把 alias provider 传给子模块。
# - 子模块如果要接收 aws.prod，必须在 required_providers 中声明 configuration_aliases = [aws.prod]。
#
# root module 负责两件事：
# 1. 在 provider.tf 里定义 provider 配置，例如默认 aws 和 aws.prod。
# 2. 在 module "buckets" 里传入业务参数和 provider 配置。
#
# 子模块不自己定义 provider 凭证、region、endpoint；它只接收调用方传进来的 provider。

# bucket 名称是 root module 决定的业务输入。
# provider 怎么传给子模块，也是 root module 决定的调用细节。
locals {
  bucket_names = {
    dev  = "tf-pro-lab-100-dev"
    prod = "tf-pro-lab-100-prod"
  }
}

# TODO: 调用 modules/buckets，传入 bucket_names，并通过 providers map 传入默认 provider 与 aws.prod。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# module "buckets" {
#   source = "./modules/buckets"
#
#   bucket_names = local.bucket_names
#
#   # 左边是子模块里使用的 provider 名称，右边是 root module 里的 provider 配置。
#   providers = {
#     aws      = aws
#     aws.prod = aws.prod
#   }
# }
#
# output "bucket_names" {
#   value = module.buckets.bucket_names
# }
