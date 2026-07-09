# 第 79 节做题环境

这是你的上机做题目录。请编辑 `network/` 和 `consumer/`，不要修改 `practice/labs/79/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS S3、DynamoDB 和 STS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- Lab78 重点是证明 consumer 能读到 network 的 remote state outputs。
- Lab79 重点是把读到的 outputs 组合成下游安全团队自己的规则对象。
- `network/` 负责输出 `public_cidr` 和 `network_owner`。
- `consumer/` 负责读取这些 outputs，并生成 `security_rule_summary`。
- `consumer/backend.hcl` 决定 consumer 自己的 state 放哪里。
- `consumer/main.tf` 里的 `data "terraform_remote_state" "network"` 才决定去哪里读取 network outputs。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\79

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

# 先打开 network\backend.hcl，重点看 key = "labs/79/network/terraform.tfstate"。
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
# 先打开 consumer\backend.hcl，理解它是 consumer 自己的 state。
# 再打开 consumer\main.tf，重点看 security_rule_summary 如何使用上游 outputs。
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

- `network` 的 state 写入 `labs/79/network/terraform.tfstate`。
- `consumer` 的 state 写入 `labs/79/consumer/terraform.tfstate`。
- `consumer` 使用 `terraform_remote_state.network.outputs.public_cidr` 生成规则说明。
- `consumer` 使用 `terraform_remote_state.network.outputs.network_owner` 标记规则来源。
- 不要手工复制 network 输出到 consumer。

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

(cd network && terraform init -input=false -backend-config=backend.hcl && terraform fmt && terraform validate && terraform plan -input=false -no-color -out=tfplan && terraform apply -auto-approve tfplan)

(cd consumer && terraform init -input=false -backend-config=backend.hcl && terraform fmt && terraform validate && terraform plan -input=false -no-color -out=tfplan && terraform apply -auto-approve tfplan && terraform output)

bash scripts/verify.sh
(cd consumer && terraform destroy -auto-approve)
(cd network && terraform destroy -auto-approve)
bash scripts/clean.sh
```
