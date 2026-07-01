# 第 75 节参考实现

本目录演示：理解写操作加锁、锁失败即停止、force-unlock 的风险，并在远端后端环境中保留锁相关配置入口。

## 本地验证

`powershell
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
terraform init -input=false -backend-config=backend.hcl
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform state list
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
`
"@
W "practice/labs/75/scripts/bootstrap.ps1" @"
$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3api create-bucket --bucket tf-pro-state-localstack --region us-east-1 2>$null
aws --endpoint-url=$endpoint dynamodb create-table --table-name tf-pro-lock-localstack --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region us-east-1 2>$null
