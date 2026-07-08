# 第 75 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/labs/75/` 中的参考实现。

本实验训练旧式 S3 backend locking：S3 保存 state，DynamoDB table 保存锁信息。Terraform 1.14 会提示 `dynamodb_table` deprecated，这是预期现象；老系统仍然常见。

## 1. 启动 LocalStack

在仓库根目录打开 PowerShell：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,dynamodb,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\75

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
```

## 3. 开始做题

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
Copy-Item backend.hcl.example backend.hcl -Force

terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform state list

pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- `backend.hcl` 中包含 `dynamodb_table = "tf-pro-lock-localstack"`。
- `terraform state list` 能看到 `terraform_data.locking_marker`。
- LocalStack S3 bucket 中存在 `labs/75/terraform.tfstate`。
- Terraform 1.14 关于 `dynamodb_table` 的 deprecated warning 是本实验预期现象。

## 4. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```

## 5. Sandbox / Linux 方式

```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export LOCALSTACK_ENDPOINT=http://localhost:4566

bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
cp backend.hcl.example backend.hcl

terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform state list
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```
