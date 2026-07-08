# 第 110 节任务

## 背景

多 Provider Alias 配置

## 知识点总结

- 默认 provider 不写 alias，资源默认使用它。
- alias provider 使用 `alias = "<NAME>"` 定义。
- 资源通过 `provider = aws.<NAME>` 显式选择 alias provider。
- 多 provider alias 常用于同一个配置管理多个 region 或账号。

## 要求

1. 定义默认 provider 和 alias provider。
2. 给资源显式设置 provider meta argument。
3. 验证两个资源都进入 state。

## Hint

可以直接参考下面的资源完成 `main.tf`：

```hcl
resource "aws_s3_bucket" "singapore" {
  bucket = "tf-pro-lab-110-a"
}

resource "aws_s3_bucket" "usa" {
  provider = aws.usa
  bucket   = "tf-pro-lab-110-b"
}

output "bucket_names" {
  value = [aws_s3_bucket.singapore.bucket, aws_s3_bucket.usa.bucket]
}
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/110/`。

## 验收标准

- 存在默认 AWS provider。
- 存在 `alias = "usa"` 的 AWS provider。
- `aws_s3_bucket.singapore` 使用默认 provider。
- `aws_s3_bucket.usa` 显式使用 `provider = aws.usa`。
- `terraform output` 能看到两个 bucket 名称。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
