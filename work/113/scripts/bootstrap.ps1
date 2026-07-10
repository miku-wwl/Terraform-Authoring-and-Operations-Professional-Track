$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$policy = Join-Path $PSScriptRoot "assume-role-trust-policy.json"

$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = "us-east-1"

aws --endpoint-url=$endpoint sts get-caller-identity | Out-Null
aws --endpoint-url=$endpoint iam get-role --role-name tf-pro-lab-113 2>$null | Out-Null

if ($LASTEXITCODE -ne 0) {
  aws --endpoint-url=$endpoint iam create-role `
    --role-name tf-pro-lab-113 `
    --assume-role-policy-document "file://$policy" | Out-Null
}

if ($LASTEXITCODE -ne 0) {
  throw "创建 IAM Role tf-pro-lab-113 失败。"
}

Write-Host "实验环境已准备：IAM Role tf-pro-lab-113 已存在。"
