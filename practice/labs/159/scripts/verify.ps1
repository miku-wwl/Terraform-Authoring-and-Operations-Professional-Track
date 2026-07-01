$ErrorActionPreference = 'Stop'
terraform output -json bucket_name | Out-Null
terraform output -json refactor_map | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
