terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      # 这不是定义 provider 配置。
      # 它只是告诉 Terraform：这个子模块允许接收名为 aws.prod 的 alias provider。
      # 真正的 aws.prod 配置由 root module 的 provider.tf 定义，再通过 module providers map 传进来。
      configuration_aliases = [aws.prod]
    }
  }
}
