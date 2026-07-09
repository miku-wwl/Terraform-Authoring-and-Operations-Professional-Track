# 第 77 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/labs/77/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS S3、DynamoDB 和 STS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- Lab77 的主题是查看远端 state，不是 state locking。
- `terraform state list` 列出当前 state 里的资源地址。
- `terraform state show <address>` 查看某个资源保存在 state 里的详细属性。
- `terraform state pull` 从当前 backend 拉取完整 state JSON，适合只读审计。
- `backend-projects/s3-for-state-audit/` 演示了远端 state 所需的 S3 bucket 如何提前创建。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\77

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
```

## 3. 开始做题

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1

# 先打开 backend.hcl，重点看 state list/show/pull 的说明。

terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan

terraform state list
terraform state show terraform_data.state_audit
terraform state pull

pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- `terraform state list` 能看到 `terraform_data.state_audit`。
- `terraform state show terraform_data.state_audit` 能看到资源当前 state。
- `terraform state pull` 能从 S3 backend 拉取完整 state JSON。
- LocalStack S3 bucket 中存在 `labs/77/terraform.tfstate`。

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
terraform state show terraform_data.state_audit
terraform state pull
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```
