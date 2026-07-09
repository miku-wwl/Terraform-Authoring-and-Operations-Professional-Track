# 第 100 节任务

## 背景

模块中的多 Provider 配置

## 知识点总结

- 一个 root module 可以定义多个同类型 provider 配置。
- 默认 provider 写成 `provider "aws" { ... }`。
- alias provider 写成 `provider "aws" { alias = "prod" ... }`，引用名是 `aws.prod`。
- root module 调用子模块时，用 `providers` map 显式传入默认 provider 和 alias provider。
- 子模块如果要使用 `aws.prod`，必须声明 `configuration_aliases = [aws.prod]`。
- 子模块资源通过 `provider = aws.prod` 选择 alias provider。

## 要求

1. 在 root module 中定义默认 AWS provider 和 alias provider。
2. 在 root module 中通过 `local.bucket_names` 准备传给子模块的业务输入。
3. 通过 module 的 `bucket_names` 参数把 bucket 名称传入子模块。
4. 通过 module 的 providers map 把默认 provider 和 alias provider 传入子模块。
5. 在子模块中声明 configuration_aliases，并让 prod bucket 使用 alias provider。

## 你需要编辑的文件

- `provider.tf`
- `main.tf`
- `modules/buckets/variables.tf`
- `modules/buckets/versions.tf`
- `modules/buckets/main.tf`

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/100/`。

## 验收标准

- root module 调用 `modules/buckets`。
- root module 通过 `bucket_names = local.bucket_names` 给子模块传参。
- module 调用中包含 `providers = { aws = aws, aws.prod = aws.prod }`。
- 子模块声明 `configuration_aliases = [aws.prod]`。
- 子模块创建两个 S3 bucket，其中 prod bucket 使用 `provider = aws.prod`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
