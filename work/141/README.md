# Lab 141：S3 Bucket Policy

本实验在 S3-only LocalStack 中创建 Bucket，并使用两条最小权限 statement 绑定 resource-based policy。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=s3 `
  localstack/localstack:4.2.0
```

已有容器不是 S3-only 时，先停止再重建。

## 2. 安全准备

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\141
Set-ExecutionPolicy -Scope Process Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

## 3. 边学边练

Bucket 已提供。完成 TODO 1 时，逐条检查 Action 对应的是 bucket ARN 还是 object ARN；完成 TODO 2 后确认 Policy 引用 Bucket ID 和 data source JSON。

完成 outputs 后运行：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

预期：`Success! 1 passed, 0 failed.`

## 4. Apply、验证、销毁

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

## Linux / Sandbox

```sh
cd work/141
. ./scripts/bootstrap.sh
sh scripts/check-sandbox.sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform apply -auto-approve
sh scripts/verify.sh
terraform destroy -auto-approve
sh scripts/clean.sh
```

本 Lab 验证策略结构和 S3 API 闭环，不代表真实 AWS 的 Block Public Access、跨账号信任或 KMS 权限已经正确。
