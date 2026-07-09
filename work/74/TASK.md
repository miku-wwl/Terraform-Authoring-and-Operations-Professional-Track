# Lab 74 任务：使用 S3 Remote Backend

## 背景

Terraform state 默认保存在本地 `terraform.tfstate`。团队协作时，state 通常要放到远端 backend 中统一管理。

本实验使用 LocalStack 模拟 S3，把 Terraform state 写入 S3 backend。

## 知识点总结

- `backend "s3" {}` 只说明使用 S3 backend。
- `backend.hcl` 才写具体的 bucket、key、region 和 LocalStack endpoint。
- `backend.hcl` 不会自动加载，必须通过 `terraform init -backend-config=backend.hcl` 传入。
- `backend-projects/s3-only/` 是一个独立小项目，用来理解 state bucket 从哪里来。

## 任务目标

你需要完成：

- 使用 `backend.tf` 中的 `backend "s3" {}` 声明 S3 backend。
- 参考 `backend.hcl.example`，自己编写 `backend.hcl`，作为 `terraform init` 的 backend 配置。
- 在 `main.tf` 中创建一个 `terraform_data` 资源，让它进入 Terraform state。
- 在 `outputs.tf` 中输出一个能证明实验完成的值。

## backend.hcl 应该怎么写

`backend.tf` 只负责声明 backend 类型：

```hcl
terraform {
  backend "s3" {}
}
```

`backend.hcl` 负责写这个 backend 的具体参数。本 lab 可以写成：

```hcl
bucket                      = "tf-pro-state-localstack"
key                         = "labs/74/terraform.tfstate"
region                      = "us-east-1"
access_key                  = "test"
secret_key                  = "test"
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
skip_requesting_account_id  = true
use_path_style              = true

endpoints = {
  s3       = "http://localhost:4566"
  dynamodb = "http://localhost:4566"
}
```

重点记住：

- `bucket` 是 state 存放的 S3 bucket。
- `key` 是 state 文件在 bucket 里的路径。
- `backend.hcl` 不会被 Terraform 自动加载，必须通过 `terraform init -backend-config=backend.hcl` 传入。
- `.example` 文件只是模板，真正使用的是你自己写出来的 `backend.hcl`。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`
- `backend.hcl`

## 需要使用的文件

- `backend.tf`
- `backend.hcl.example`
- `backend-projects/s3-only/`

## 禁止事项

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/74/`。

## 验收标准

- `terraform init -backend-config=backend.hcl` 成功。
- `terraform state list` 能看到 `terraform_data.backend_marker`。
- LocalStack S3 中存在 `labs/74/terraform.tfstate`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
