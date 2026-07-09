$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-109 --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-109 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-109-a --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-109-a 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-109-b --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-109-b 2>$null
Remove-Item -Recurse -Force .terraform, .terraform.lock.hcl, .terraform.tfstate.lock.info, tfplan, aws-config, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host "第 109 节本地文件已清理。"

