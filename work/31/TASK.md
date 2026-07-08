# Lab 31 任务：读取已有 EC2 实例列表

## 背景

本实验不会连接真实 AWS。你会先用 Docker 启动 LocalStack，再通过 `scripts/bootstrap.ps1` 或 `scripts/bootstrap.sh` 创建两台带 `Project=tf-lab-31` 标签的模拟 EC2。

## 任务目标

你需要使用 Terraform data source 读取这些已有实例，而不是创建新实例。

## 你需要编辑的文件

- `main.tf`

`outputs.tf` 已经写好，用来显示 data source 的读取结果。你主要练习的是在 `main.tf` 中声明 `data "aws_instances" "lab"`。

## 禁止事项

- 不要创建 `aws_instance` resource。
- 不要访问真实 AWS。
- 不要修改 `provider.tf` 中的 LocalStack endpoint。

## 验收标准

- `terraform validate` 通过。
- `terraform apply` 后输出 `lab_instance_ids`。
- `terraform apply` 后输出 `lab_instance_count`，值应为 `2`。
- Windows 上 `pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1` 通过。
- WSL / Linux / Terraform Sandbox 中 `bash scripts/verify.sh` 通过。

## Windows 建议执行顺序

先按 `README.md` 启动 LocalStack，并设置环境变量，然后执行：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
```

## WSL / Linux / Sandbox 建议执行顺序

```sh
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
```
