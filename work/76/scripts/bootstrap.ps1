$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
cmd /c "aws --endpoint-url=$endpoint s3api create-bucket --bucket tf-pro-state-localstack --region us-east-1 2>nul || exit /b 0" | Out-Null
Write-Host "S3 bucket 已准备。"
