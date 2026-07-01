# 第 76 节任务

## 背景

你需要为新项目配置 S3 backend state locking。这个项目不再使用 DynamoDB lock table，而是使用 Terraform S3 backend 的新式 `use_lockfile`。

## 要求

1. 复制 `backend.hcl.example` 为 `backend.hcl`。
2. 确认 backend 使用 `use_lockfile = true`。
3. 不要配置 `dynamodb_table`。
4. 补全 `main.tf` 和 `outputs.tf`，创建一个能进入 state 的 `terraform_data` 资源。
5. 按 README 执行验证流程，确保 `terraform state list` 和 `scripts/verify.ps1` 通过。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/76/`。
