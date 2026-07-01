$ErrorActionPreference = 'Stop'
terraform output -json caller_account | Out-Null
terraform output -json bucket_name | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
