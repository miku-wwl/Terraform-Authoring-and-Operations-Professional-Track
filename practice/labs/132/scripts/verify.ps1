$ErrorActionPreference = 'Stop'
terraform output -raw account_id | Out-Null
terraform output -raw caller_arn | Out-Null
Write-Host 'PASS: caller identity outputs exist.'
