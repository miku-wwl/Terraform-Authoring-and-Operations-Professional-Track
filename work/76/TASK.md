# 第 76 节任务

## 背景

你需要为新项目配置 S3 backend state locking。这个项目不再使用 DynamoDB lock table，而是使用 Terraform S3 backend 的新式 `use_lockfile`。

## 知识点总结

- `use_lockfile = true` 让 Terraform 使用 S3 lockfile 做 state locking。
- 这种方式不需要 DynamoDB table。
- S3 bucket 本身不需要特殊 state-lock 开关；锁由 Terraform backend 通过 S3 object 管理。
- `.tflock` 是过程文件，通常只在 Terraform 正在持锁时短暂出现。

## 要求

1. 阅读 `backend.hcl`，确认 backend 使用 `use_lockfile = true`。
2. 对照 `backend.hcl.example`，理解它和 Lab75 的 `dynamodb_table` 差异。
3. 不要配置 `dynamodb_table`。
4. 补全 `main.tf` 和 `outputs.tf`，创建一个能进入 state 的 `terraform_data` 资源。
5. 查看 `backend-projects/s3-with-lockfile/`，理解这种方式只需要提前准备 S3 bucket。
6. 按 README 执行验证流程，确保 `terraform state list` 和 `scripts/verify.ps1` 通过。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/76/`。

## 验收标准

- `terraform init -backend-config=backend.hcl` 成功。
- `backend.hcl` 包含 `use_lockfile = true`，且不包含 `dynamodb_table`。
- `terraform state list` 能看到 `terraform_data.s3_lockfile_marker`。
- LocalStack S3 中存在 `labs/76/terraform.tfstate`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
