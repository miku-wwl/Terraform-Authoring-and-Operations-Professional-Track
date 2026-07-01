$ErrorActionPreference = 'Stop'
terraform output -json bucket_name | Out-Null
terraform output -json object_key | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
