# 第 105 节任务

## 背景

把根配置拆分为子模块

## 要求

1. 把 DynamoDB 与 S3 资源拆入不同 child module。
2. 在 root module 写 moved block。
3. 验证迁移后 state 地址进入 module。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/105/`。

## 验收标准

- root module 调用 `modules/database` 和 `modules/storage`。
- database 子模块创建 `aws_dynamodb_table.platform` 并输出 `table_name`。
- storage 子模块创建 `aws_s3_bucket.audit` 并输出 `bucket_name`。
- 使用 `moved` block 表达 `aws_dynamodb_table.platform` 到 `module.database.aws_dynamodb_table.platform` 的迁移。
- 使用 `moved` block 表达 `aws_s3_bucket.audit` 到 `module.storage.aws_s3_bucket.audit` 的迁移。
- `terraform state list` 能看到资源地址进入 module。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
