$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
aws --endpoint-url=$endpoint s3 rm s3://tf-pro-state-localstack/labs/75/ --recursive 2>$null
cmd /c "aws --endpoint-url=$endpoint dynamodb delete-table --table-name tf-pro-lock-localstack 2>nul || exit /b 0" | Out-Null
Remove-Item -Recurse -Force .terraform,.terraform.lock.hcl,backend.hcl,tfplan 2>$null
Write-Host "第 75 节本地实验文件已清理。"
