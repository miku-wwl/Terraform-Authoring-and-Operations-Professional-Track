# 第 78 节参考实现

本目录演示 network 与 consumer 两个 Terraform 配置通过 S3 remote state 串联。

## 本地验证

`powershell
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1

cd network
terraform init -input=false -backend-config=backend.hcl
terraform apply -auto-approve
cd ..\consumer
terraform init -input=false -backend-config=backend.hcl
terraform apply -auto-approve
terraform output allowed_cidr_from_remote_state
cd ..
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
`
"@
W "practice/labs/78/scripts/bootstrap.ps1" (PsBootstrap)
W "practice/labs/78/scripts/verify.ps1" @"
$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
Push-Location consumer
terraform output -raw allowed_cidr_from_remote_state | Select-String "203.0.113.78/32" | Out-Null
Pop-Location
aws --endpoint-url=$endpoint s3api head-object --bucket tf-pro-state-localstack --key labs/78/network/terraform.tfstate | Out-Null
aws --endpoint-url=$endpoint s3api head-object --bucket tf-pro-state-localstack --key labs/78/consumer/terraform.tfstate | Out-Null
Write-Host "第 78 节验证通过：consumer 已读取 network remote state。"
