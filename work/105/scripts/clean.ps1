$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-105-audit --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-105-audit 2>$null
aws --endpoint-url=$endpoint dynamodb delete-table --table-name tf-pro-lab-105-platform 2>$null
Remove-Item -Recurse -Force .terraform, .terraform.lock.hcl, tfplan, aws-config, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host "第 105 节本地文件已清理。"

