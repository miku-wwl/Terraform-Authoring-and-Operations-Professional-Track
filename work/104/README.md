# 第 104 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/104/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\104
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 开始做题

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
terraform destroy -auto-approve
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- root module 调用 `modules/buckets`，并设置 `bucket_count = 3`。
- 子模块内部 `aws_s3_bucket.this` 使用 `count = var.bucket_count`。
- root module 的 `moved` block 从 `module.buckets.aws_s3_bucket.this` 迁移到 `module.buckets.aws_s3_bucket.this[1]`。
- `terraform state list` 能看到带 index 的模块资源地址。

## 4. Sandbox / Linux 方式

```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export LOCALSTACK_ENDPOINT=http://localhost:4566
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```

## 5. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```
