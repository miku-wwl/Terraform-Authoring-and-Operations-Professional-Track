terraform {
  required_version = ">= 1.12.0"
}

# Lab 75 知识点总结：
# - Lab 74 解决的是 state 放哪里；Lab 75 增加的是多人协作时的 state locking。
# - S3 backend 负责保存 state，DynamoDB table 负责保存锁记录，避免多人同时修改同一份 state。
# - backend.hcl.example 中的 dynamodb_table = "tf-pro-lock-localstack" 就是旧式 S3 backend locking 配置。
# - Terraform 1.14 会提示 dynamodb_table deprecated，这是预期现象；很多老项目仍会遇到这种配置。
# - 锁表需要有名为 LockID 的字符串主键；本实验由 scripts/bootstrap.ps1 预先创建。
# - terraform_data 是 Terraform 内置资源，适合在实验中创建一个轻量对象来证明 state 和 locking 流程可用。

# TODO: 创建一个 terraform_data 资源，让它能被写入远端 state。
# Hint：可以直接参考下面这段，把注释去掉即可。
#
# resource "terraform_data" "locking_marker" {
#   input = {
#     lab   = "75"
#     topic = "State Locking 基础"
#   }
# }
