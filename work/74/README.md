# 第 74 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 practice/labs/74/ 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS S3、DynamoDB 和 STS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 1. 启动 LocalStack

在仓库根目录打开 PowerShell：

`powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,dynamodb,sts `
  localstack/localstack:4.2.0
`

## 2. 进入实验目录

`powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\74

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
`

## 3. 开始做题

`powershell
powershell -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
Copy-Item backend.hcl.example backend.hcl -Force

terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform state list

powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
`

## 4. 清理 LocalStack

`powershell
docker stop localstack-tf-labs
`

## 5. Terraform 官方 Sandbox / Linux 方式

如果你在网页 Sandbox 或 Linux 终端中做题，先启动或进入可访问 LocalStack 的环境，然后执行：

`sh
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
`
"@
W "work/74/TASK.md" @"
# 第 74 节任务

## 背景

把 Terraform state 从本地迁移到 S3 backend，并确认本地目录不再生成 terraform.tfstate。

## 要求

1. 补全 ackend.hcl.example 并复制为 ackend.hcl。
2. 让 Terraform 使用 S3 backend，state key 必须是 labs/74/terraform.tfstate。
3. 补全 main.tf 和 outputs.tf，创建一个能进入 state 的 	erraform_data 资源。
4. 运行 README 中的验证流程，确保 	erraform state list 和 scripts/verify.ps1 通过。

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 practice/labs/74/。
