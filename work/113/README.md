# 第 113 节：观察 AssumeRole 前后的身份

Lab112 重点是会写 `assume_role`。本节通过 provider alias 和 `aws_caller_identity`，观察 AWS Provider 调用 STS 前后的真实身份变化。

## 你会练到什么

- 默认 provider：使用基础凭证，是 AssumeRole 的发起者。
- `aws.assumed`：通过 STS 获得临时身份。
- `data "aws_caller_identity"`：查询某个 provider 当前代表谁。
- `provider = aws.assumed`：明确让 data source 或 resource 使用临时身份。
- trust policy：目标 Role 必须信任发起 AssumeRole 的身份。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,iam,sts `
  localstack/localstack:4.2.0
```

容器已经存在时，只需确认它仍在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 准备实验环境

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\113
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
```

`bootstrap.ps1` 会创建 `tf-pro-lab-113` IAM Role。它的 trust policy 允许实验账号调用 `sts:AssumeRole`。

可以先确认 Role 已存在：

```powershell
aws --endpoint-url=$env:LOCALSTACK_ENDPOINT iam get-role --role-name tf-pro-lab-113
```

## 3. 完成练习

按照 `provider.tf` 和 `main.tf` 中的 TODO，依次取消 Hint 代码的注释。

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output identity_comparison
terraform output bucket_name
```

重点观察 `identity_comparison`：

- `base_arn` 是默认 provider 的基础身份。
- `assumed_arn` 应包含 `assumed-role/tf-pro-lab-113`。
- `changed = true` 说明两个 provider 使用的身份不同。

## 4. 验收与清理

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## Linux / Sandbox

```sh
export LOCALSTACK_ENDPOINT=http://localhost:4566
export TF_VAR_localstack_endpoint=http://localhost:4566
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output identity_comparison
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```

整个实验结束后，如需停止 LocalStack：

```powershell
docker stop localstack-tf-labs
```
