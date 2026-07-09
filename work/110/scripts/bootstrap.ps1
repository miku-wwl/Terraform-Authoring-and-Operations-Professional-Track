$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = "us-east-1"
aws --endpoint-url=$endpoint sts get-caller-identity | Out-Null
Write-Host "实验预检完成。"
