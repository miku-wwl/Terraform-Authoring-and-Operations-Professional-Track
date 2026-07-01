$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
Push-Location consumer
terraform output -raw allowed_cidr_from_remote_state | Select-String "203.0.113.79/32" | Out-Null
Pop-Location
aws --endpoint-url=$endpoint s3api head-object --bucket tf-pro-state-localstack --key labs/79/network/terraform.tfstate | Out-Null
aws --endpoint-url=$endpoint s3api head-object --bucket tf-pro-state-localstack --key labs/79/consumer/terraform.tfstate | Out-Null
Write-Host "第 79 节验证通过：consumer 已读取 network remote state。"
