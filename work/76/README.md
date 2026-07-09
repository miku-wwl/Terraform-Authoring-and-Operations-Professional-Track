# 第 76 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/labs/76/` 中的参考实现。

本实验训练新式 S3 backend locking：S3 保存 state，并通过 `use_lockfile = true` 使用 S3 lockfile。这个方式不需要 DynamoDB table，更适合新 Terraform 项目。

## 知识点总结

- Lab75 使用 DynamoDB 锁表；Lab76 使用新式 S3 lockfile。
- `use_lockfile = true` 是 backend 配置，不是 S3 bucket 资源上的开关。
- Lab74 和 Lab76 提前创建的 S3 bucket 可以一样，差异在 backend 怎么使用它。
- `.tflock` 只在 Terraform 持锁期间短暂存在，apply 结束后会被删除。
- `backend-projects/s3-with-lockfile/` 演示了这种方式只需要提前准备 S3 bucket。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\76

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
```

## 3. 开始做题

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1

# 先打开 backend.hcl，重点看 use_lockfile = true。

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

- `backend.hcl` 中包含 `use_lockfile = true`。
- `backend.hcl` 中不要配置 `dynamodb_table`。
- `terraform state list` 能看到 `terraform_data.s3_lockfile_marker`。
- LocalStack S3 bucket 中存在 `labs/76/terraform.tfstate`。

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
