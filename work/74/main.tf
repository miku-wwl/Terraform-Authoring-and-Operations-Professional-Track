terraform {
  required_version = ">= 1.12.0"
}

# Lab 74 知识点总结：
# - Terraform state 默认保存在本地 terraform.tfstate；remote backend 可以把 state 放到共享位置。
# - backend "s3" 表示使用 S3 存储 state；本实验用 LocalStack 模拟 S3，不访问真实 AWS。
# - backend 配置不能引用变量，所以 bucket、key、endpoint 等通常放在 backend.hcl 里给 terraform init 使用。
# - backend.tf 只声明后端类型；backend.hcl.example 提供可复制的初始化参数。
# - key = "labs/74/terraform.tfstate" 决定 state 文件在 S3 bucket 里的对象路径。
# - terraform_data 是 Terraform 内置资源，适合在实验中创建一个轻量对象来证明 state 已写入 backend。

resource "terraform_data" "backend_marker" {
  input = {
    lab   = "74"
    topic = "S3 中央后端"
  }
}
