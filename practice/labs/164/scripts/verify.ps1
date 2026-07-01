$ErrorActionPreference = 'Stop'
terraform output -json instance_specs | Out-Null
terraform output -json instance_count | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
