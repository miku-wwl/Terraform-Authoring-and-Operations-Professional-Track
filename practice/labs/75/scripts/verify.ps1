$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
terraform state list | Select-String "locking_marker" | Out-Null
aws --endpoint-url=$endpoint s3api head-object --bucket tf-pro-state-localstack --key labs/75/terraform.tfstate | Out-Null
Write-Host "第 75 节验证通过：state 已写入 LocalStack S3 backend。"
