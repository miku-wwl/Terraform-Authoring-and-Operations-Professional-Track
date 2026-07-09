$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-111 --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-111 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-111-a --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-111-a 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-111-b --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-111-b 2>$null
Remove-Item -Recurse -Force .terraform, .terraform.lock.hcl, .terraform.tfstate.lock.info, tfplan, aws-config, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host "第 111 节本地文件已清理。"

