$ErrorActionPreference = 'Stop'
terraform output -raw policy_json | Out-Null
terraform output -raw policy_arn | Out-Null
Write-Host 'PASS: policy document and iam policy outputs exist.'
