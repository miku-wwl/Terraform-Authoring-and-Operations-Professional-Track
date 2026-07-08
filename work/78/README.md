# 第 78 节做题环境

这是你的上机做题目录。请编辑 `network/` 和 `consumer/`，不要修改 `practice/labs/78/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS S3、DynamoDB 和 STS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\78

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
```

## 3. 开始做题

先 apply 上游 `network`，让它把 outputs 写入 remote state：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1

Copy-Item network\backend.hcl.example network\backend.hcl -Force
Set-Location network
terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
Set-Location ..
```

再 apply 下游 `consumer`，让它用 `terraform_remote_state` 读取 network outputs：

```powershell
Copy-Item consumer\backend.hcl.example consumer\backend.hcl -Force
Set-Location consumer
terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
Set-Location ..

pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
Set-Location consumer; terraform destroy -auto-approve; Set-Location ..
Set-Location network; terraform destroy -auto-approve; Set-Location ..
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- `network` 的 state 写入 `labs/78/network/terraform.tfstate`。
- `consumer` 的 state 写入 `labs/78/consumer/terraform.tfstate`。
- `consumer` 不能手工复制 CIDR，必须通过 `terraform_remote_state.network.outputs.public_cidr` 读取。

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

cp network/backend.hcl.example network/backend.hcl
(cd network && terraform init -input=false -backend-config=backend.hcl && terraform fmt && terraform validate && terraform plan -input=false -no-color -out=tfplan && terraform apply -auto-approve tfplan)

cp consumer/backend.hcl.example consumer/backend.hcl
(cd consumer && terraform init -input=false -backend-config=backend.hcl && terraform fmt && terraform validate && terraform plan -input=false -no-color -out=tfplan && terraform apply -auto-approve tfplan && terraform output)

bash scripts/verify.sh
(cd consumer && terraform destroy -auto-approve)
(cd network && terraform destroy -auto-approve)
bash scripts/clean.sh
```
