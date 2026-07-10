$ErrorActionPreference = "SilentlyContinue"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = "us-east-1"

aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-113 --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-113 2>$null
aws --endpoint-url=$endpoint iam delete-role --role-name tf-pro-lab-113 2>$null

Remove-Item -Recurse -Force .terraform 2>$null
Remove-Item -Force .terraform.lock.hcl,tfplan,terraform.tfstate,terraform.tfstate.backup 2>$null
Write-Host "第 113 节环境已清理。"
