# 第 78 节做题环境

这是你的上机做题目录。请编辑 
etwork/ 和 consumer/，不要修改 practice/labs/78/ 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS S3、DynamoDB 和 STS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 1. 启动 LocalStack

`powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,dynamodb,sts `
  localstack/localstack:4.2.0
`

## 2. 进入实验目录

`powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\78
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
`

## 3. 开始做题

`powershell
powershell -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1

Copy-Item network\backend.hcl.example network\backend.hcl -Force
cd network
terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
cd ..

Copy-Item consumer\backend.hcl.example consumer\backend.hcl -Force
cd consumer
terraform init -input=false -backend-config=backend.hcl
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
cd ..

powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
cd consumer; terraform destroy -auto-approve; cd ..
cd network; terraform destroy -auto-approve; cd ..
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
`

## 4. 清理 LocalStack

`powershell
docker stop localstack-tf-labs
`

## 5. Terraform 官方 Sandbox / Linux 方式

`sh
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
`
"@
W "work/78/TASK.md" @"
# 第 78 节任务

## 背景

让 consumer 配置读取 network 团队写入 S3 backend 的输出值，理解跨团队状态依赖。

## 要求

1. 在 
etwork/ 中创建一个输出 public_cidr 和 
etwork_owner 的配置，并把 state 写入 labs/78/network/terraform.tfstate。
2. 在 consumer/ 中使用 	erraform_remote_state 读取 network 的输出。
3. 在 consumer/ 中创建一个资源，证明它使用了 remote state 读取到的 CIDR。
4. 按 README 顺序完成验证和销毁。

## 限制

- 不要使用真实 AWS。
- 不要手工复制 network 输出到 consumer。
- 不要修改 practice/labs/78/。
