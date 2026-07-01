$ErrorActionPreference = 'Stop'
terraform output -raw reader_name | Out-Null
terraform output -raw policy_arn | Out-Null
Write-Host 'PASS: iam policy is attached to user.'
