$ErrorActionPreference = 'Stop'
terraform output -json subnet_ids | Out-Null
terraform output -json rule_summary | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
