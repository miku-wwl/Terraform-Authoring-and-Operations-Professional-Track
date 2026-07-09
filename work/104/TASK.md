# 第 104 节任务

## 背景

为模块内部资源启用 count

## 要求

1. 在 child module 中为 S3 bucket 启用 count。
2. 在 root module 中写 moved block，把旧地址迁移到指定 index。
3. 验证 state list 中出现带 index 的模块资源地址。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/104/`。

## 验收标准

- root module 调用 `modules/buckets`，并设置 `bucket_count = 3`。
- 子模块使用变量 `bucket_count` 控制 `aws_s3_bucket.this` 的 `count`。
- 使用 `moved` block 表达 `module.buckets.aws_s3_bucket.this` 到 `module.buckets.aws_s3_bucket.this[1]` 的迁移。
- `terraform state list` 能看到带 index 的模块资源地址。
- `terraform output` 能看到 S3 bucket 名称列表。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
