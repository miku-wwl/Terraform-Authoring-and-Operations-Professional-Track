# Lab 77 任务：查看远端 Terraform State

## 背景

Terraform state 已经存放在 S3 backend 中。本实验练习通过 Terraform CLI 查看远端 state，而不是手工打开或编辑 state 文件。

## 任务目标

你需要完成：

- 使用 `backend.tf` 中的 `backend "s3" {}` 声明 S3 backend。
- 将 `backend.hcl.example` 复制为 `backend.hcl`，作为 `terraform init` 的 backend 配置。
- 在 `main.tf` 中创建一个 `terraform_data` 资源，让它进入 Terraform state。
- 在 `outputs.tf` 中输出一个能证明实验完成的值。
- 使用 `terraform state list`、`terraform state show` 和 `terraform state pull` 查看远端 state。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 需要使用的文件

- `backend.tf`
- `backend.hcl.example`

## 禁止事项

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要手工编辑 state 文件。
- 不要修改 `practice/labs/77/`。

## 验收标准

- `terraform init -backend-config=backend.hcl` 成功。
- `terraform state list` 能看到 `terraform_data.state_audit`。
- `terraform state show terraform_data.state_audit` 能显示资源 state。
- LocalStack S3 中存在 `labs/77/terraform.tfstate`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
