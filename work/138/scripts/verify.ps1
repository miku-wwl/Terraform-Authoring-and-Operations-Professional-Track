$ErrorActionPreference = 'Stop'
terraform output -raw attached_policy_arn | Out-Null
Write-Host 'PASS: iam role policy attachment exists.'
