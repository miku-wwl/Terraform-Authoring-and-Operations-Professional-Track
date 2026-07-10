# Lab 140：Auto Scaling Group 与 Launch Template

本实验真实创建 VPC、双 AZ Subnet 和 Launch Template，再用 Terraform local 建模 ASG。LocalStack Community 4.2.0 不执行 ASG API，所以不会启动实例。

## 1. 启动 EC2-only LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -e SERVICES=ec2 `
  localstack/localstack:4.2.0
```

## 2. 安全准备

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\140
Set-ExecutionPolicy -Scope Process Bypass -Force
& .\scripts\bootstrap.ps1
& .\scripts\check-sandbox.ps1
```

## 3. 边学边练

先阅读 `main.tf`，运行 init/fmt/validate/plan，观察 4 个真实 EC2 资源。完成 TODO 1 后，确认 `asg_spec` 的字段可逐项映射到真实 `aws_autoscaling_group`。

完成 TODO 2 后运行：

```powershell
terraform fmt -check
terraform validate
terraform test
```

预期：`Success! 1 passed, 0 failed.`

## 4. Apply、验证与清理

```powershell
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
& .\scripts\verify.ps1
terraform destroy -auto-approve
& .\scripts\clean.ps1
```

输出是 ASG 配置模型；不要把它误认为真实 ASG 或实例。

## Linux / Sandbox

```sh
cd work/140
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

真实 AWS 中建议跨多个 AZ subnet，并明确 Launch Template 的版本策略；扩缩容行为需要在受控 AWS sandbox 验证。
