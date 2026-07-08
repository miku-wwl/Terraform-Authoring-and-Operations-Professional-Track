# Lab 74 任务：使用 S3 Remote Backend

## 背景

Terraform state 默认保存在本地 `terraform.tfstate`。团队协作时，state 通常要放到远端 backend 中统一管理。

本实验使用 LocalStack 模拟 S3，把 Terraform state 写入 S3 backend。

## 任务目标

你需要完成：

- 使用 `backend.tf` 中的 `backend "s3" {}` 声明 S3 backend。
- 将 `backend.hcl.example` 复制为 `backend.hcl`，作为 `terraform init` 的 backend 配置。
- 在 `main.tf` 中创建一个 `terraform_data` 资源，让它进入 Terraform state。
- 在 `outputs.tf` 中输出一个能证明实验完成的值。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 需要使用的文件

- `backend.tf`
- `backend.hcl.example`

## 禁止事项

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/74/`。

## 验收标准

- `terraform init -backend-config=backend.hcl` 成功。
- `terraform state list` 能看到 `terraform_data.backend_marker`。
- LocalStack S3 中存在 `labs/74/terraform.tfstate`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
