# Lab 32 任务：区分 Resource 与 Data Source

## 背景

本实验不会连接真实 AWS。你会先用 Docker 启动 LocalStack，然后用 Terraform 的只读 data source 确认当前 provider 连接的是 LocalStack 模拟账号，而不是你的真实 AWS 账号。

## 任务目标

使用 AWS provider 的只读 data source 输出当前账号 ID、调用者 ARN 和 region。

## 你需要编辑的文件

- `main.tf`
- `outputs.tf`

## 禁止事项

- 不要创建任何 AWS resource。
- 不要配置真实 access key。
- 不要删除 provider 中的 LocalStack endpoint。

## 验收标准

- `account_id` 输出为 `000000000000`。
- `caller_arn` 和 `current_region` 有值。
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
