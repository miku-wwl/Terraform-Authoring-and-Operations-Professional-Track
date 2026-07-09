# 第 110 节任务

## 主题

Provider alias：同一个 Terraform 配置里同时使用默认 provider 和 alias provider。

## 这节和 Lab100 的区别

```text
Lab110：resource / data source 直接选择 provider alias。
Lab100：root module 把 provider alias 传给 child module。
```

所以本节是 provider alias 的基础观察题。

## 知识点总结

- 没有 `alias` 的 provider 是默认 provider。
- 带 `alias = "usa"` 的 provider 需要显式使用 `provider = aws.usa`。
- resource 不写 `provider` 时，会使用默认 provider。
- data source 也可以写 `provider = aws.usa`。
- 本实验通过 `data "aws_region"` 输出两个 provider 的实际 region。

## 要求

1. 用默认 provider 读取默认 region。
2. 用 `aws.usa` alias provider 读取 USA region。
3. 创建一个默认 provider bucket。
4. 创建一个显式使用 `aws.usa` 的 bucket。
5. 输出两个 provider region 和两个 bucket 名称。

## Hint

可以直接参考下面内容完成 `main.tf`：

```hcl
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
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/110/`。

## 验收标准

- 存在默认 AWS provider，region 是 `ap-southeast-1`。
- 存在 `alias = "usa"` 的 AWS provider，region 是 `us-east-1`。
- `data.aws_region.default` 使用默认 provider。
- `data.aws_region.usa` 显式使用 `provider = aws.usa`。
- `aws_s3_bucket.singapore` 使用默认 provider。
- `aws_s3_bucket.usa` 显式使用 `provider = aws.usa`。
- `terraform output` 能看到 `default_region`、`usa_region` 和两个 bucket 名称。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
