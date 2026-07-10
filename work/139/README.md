# Lab 139：Launch Template 基础配置

本实验在 LocalStack EC2 中创建 VPC、Security Group 和 Launch Template，不启动实例。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=ec2 `
  localstack/localstack:4.2.0
```

已有容器未启用 EC2 时，先 `docker stop localstack-tf-labs` 再重建。

## 2. 安全准备

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\139
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

## 3. 边学边练

先阅读 `main.tf` 顶部总结。VPC 与 Security Group 已提供，先运行：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color
```

完成 TODO 1 后，plan 应新增 Launch Template，并显示 Security Group ID 来自上游引用。注意顶层 `tags` 标记模板，`tag_specifications` 标记未来实例。

LocalStack 4.2.0 可能无法回读 `tag_specifications.tags`；本 Lab 因此复用同一个 local 验证配置意图，并在文档中明确这一模拟器限制。

完成 TODO 2 后运行：

```powershell
terraform fmt -check
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
cd work/139
. ./scripts/bootstrap.sh
sh scripts/check-sandbox.sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
sh scripts/verify.sh
terraform destroy -auto-approve
sh scripts/clean.sh
```

Launch Template 参数在创建时不会被完整验证，所以本实验只证明 Terraform → LocalStack EC2 的模板闭环，不证明未来实例一定能启动。
