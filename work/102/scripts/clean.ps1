$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-102 --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-102 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-102-a --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-102-a 2>$null
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-lab-102-b --recursive 2>$null
aws --endpoint-url=$endpoint s3api delete-bucket --bucket tf-pro-lab-102-b 2>$null
Remove-Item -Recurse -Force .terraform,.terraform.lock.hcl,tfplan,aws-config 2>$null,terraform.tfstate,terraform.tfstate.backup
Write-Host "第 102 节本地文件已清理。"

