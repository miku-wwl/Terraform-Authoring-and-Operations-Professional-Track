$ErrorActionPreference = 'Stop'
terraform output -json vpc_id | Out-Null
terraform output -json subnet_ids | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
