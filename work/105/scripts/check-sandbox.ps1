$ErrorActionPreference = "Stop"
terraform version | Out-Null
aws --version | Out-Null
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint sts get-caller-identity | Out-Null
Write-Host "LocalStack 连接正常。"
