terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      # 子模块要使用 aws.prod 这种 alias provider，必须先在这里声明它是可接收的 provider 配置。
      configuration_aliases = [aws.prod]
    }
  }
}
