$ErrorActionPreference = 'Stop'
terraform output -json instance_ids | Out-Null
terraform output -json instance_summary | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
