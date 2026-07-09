# 第 75 节任务

## 背景

你需要维护一个旧式 Terraform 后端：S3 保存 state，DynamoDB table 保存锁信息。这个写法在 Terraform 1.14 中会出现 deprecated warning，但仍然是大量老系统的现实配置。

## 知识点总结

- S3 bucket 保存远端 state。
- DynamoDB table 保存旧式 state lock/digest 信息。
- `dynamodb_table` 是旧式 S3 backend locking 参数，新 Terraform 会提示 deprecated。
- 本 lab 的目标是看懂老系统配置，而不是推荐新项目继续使用它。

## 要求

1. 阅读 `backend.hcl`，确认 backend 使用 `dynamodb_table = "tf-pro-lock-localstack"`。
2. 对照 `backend.hcl.example`，理解这个字段和 Lab74 的差异。
3. 补全 `main.tf` 和 `outputs.tf`，创建一个能进入 state 的 `terraform_data` 资源。
4. 查看 `backend-projects/s3-with-dynamodb-lock/`，理解 S3 bucket 和 DynamoDB lock table 如何提前创建。
5. 按 README 执行验证流程，确保 `terraform state list` 和 `scripts/verify.ps1` 通过。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/75/`。

## 验收标准

- `terraform init -backend-config=backend.hcl` 成功。
- `terraform state list` 能看到 `terraform_data.locking_marker`。
- LocalStack S3 中存在 `labs/75/terraform.tfstate`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
