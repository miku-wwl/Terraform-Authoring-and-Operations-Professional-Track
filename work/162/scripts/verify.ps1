$ErrorActionPreference = 'Stop'
terraform output -json local_file_path | Out-Null
terraform output -json object_key | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
