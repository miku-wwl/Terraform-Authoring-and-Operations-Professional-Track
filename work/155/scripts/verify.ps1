$ErrorActionPreference = 'Stop'
terraform output -json artifact_files | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
