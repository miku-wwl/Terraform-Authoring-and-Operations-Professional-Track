$ErrorActionPreference = 'Stop'
terraform output -json bucket_name | Out-Null
terraform output -json operator_name | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
