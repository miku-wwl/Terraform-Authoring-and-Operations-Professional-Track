# 第 102 节任务

## 背景

为已有资源启用 count

## 要求

1. 先理解旧地址和新地址。
2. 使用 moved block 表达 state 地址迁移。
3. 确保 plan 不出现非预期 destroy。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/102/`。

## 验收标准

- 使用 `resource "aws_s3_bucket" "instances"`，并设置 `count = 2`。
- 使用 `moved` block 表达 `aws_s3_bucket.a` 到 `aws_s3_bucket.instances[0]` 的迁移。
- 使用 `moved` block 表达 `aws_s3_bucket.b` 到 `aws_s3_bucket.instances[1]` 的迁移。
- `terraform plan` 不出现非预期 destroy。
- `terraform output` 能看到两个 bucket 名称。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
