$ErrorActionPreference = 'Stop'
terraform output -json vpc_id | Out-Null
terraform output -json security_group_id | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
