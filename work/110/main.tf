# Lab 110 知识点总结：
# - provider alias 用来在同一个 Terraform 配置中定义同类型 provider 的多个实例。
# - 没有 alias 的 provider 是默认 provider，资源不写 provider 时会使用它。
# - 带 alias 的 provider 通过 provider = aws.<ALIAS> 显式选择。
# - 本实验中默认 provider 表示 ap-southeast-1，alias provider aws.usa 表示 us-east-1。
# - data source 和 resource 都可以通过 provider meta argument 选择 provider。
# - 本实验会输出两个 provider 的实际 region，直观看到 alias 是否生效。

data "aws_region" "default" {}

data "aws_region" "usa" {
  provider = aws.usa
}

resource "aws_s3_bucket" "singapore" {
  bucket = "tf-pro-lab-110-a"
}

resource "aws_s3_bucket" "usa" {
  provider = aws.usa
  bucket   = "tf-pro-lab-110-b"
}

output "provider_alias_summary" {
  value = {
    default_region = data.aws_region.default.name
    usa_region     = data.aws_region.usa.name
    singapore      = aws_s3_bucket.singapore.bucket
    usa            = aws_s3_bucket.usa.bucket
  }
}
