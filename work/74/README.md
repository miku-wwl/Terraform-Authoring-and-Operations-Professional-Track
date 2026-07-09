# 第 74 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/labs/74/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS S3、DynamoDB 和 STS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- `backend.tf` 只声明 backend 类型：`backend "s3" {}`。
- `backend.hcl` 提供 S3 backend 的具体参数，例如 `bucket`、`key`、`region`。
- `terraform init -backend-config=backend.hcl` 会把当前目录连接到指定 backend。
- state 写入 S3 backend 后，项目根目录不再依赖本地 `terraform.tfstate` 保存最终状态。
- `backend-projects/s3-only/` 演示了 remote backend 背后的 S3 bucket 可以如何提前创建。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\74

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
```

## 3. 编写 backend.hcl

`backend.tf` 里只声明 backend 类型：

```hcl
terraform {
  backend "s3" {}
}
```

真正的 S3 backend 参数放在 `backend.hcl` 中。你可以参考 `backend.hcl.example`，自己新建 `backend.hcl`：

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

这些字段的作用：

- `bucket`：state 要存到哪个 S3 bucket。
- `key`：state 文件在 bucket 里的路径。
- `region`：backend 使用的 AWS region。
- `access_key` / `secret_key`：LocalStack 测试凭证，不要用于真实 AWS。
- `skip_*`：跳过真实 AWS 校验，方便连接 LocalStack。
- `use_path_style`：让 S3 请求使用 LocalStack 兼容的 path-style 地址。
- `endpoints`：把 S3/DynamoDB 请求指向本机 LocalStack。

如果你只是想快速开始，也可以先复制模板：

```powershell
Copy-Item backend.hcl.example backend.hcl -Force
```

本目录已经提供带注释的 `backend.hcl`，第一次学习时建议直接打开它逐行读一遍。

## 4. 开始做题

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1

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

- `terraform state list` 能看到 `terraform_data.backend_marker`。
- LocalStack S3 bucket 中存在 `labs/74/terraform.tfstate`。
- 本地目录不依赖 `terraform.tfstate` 保存最终 state。

## 5. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```

## 6. Sandbox / Linux 方式

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
