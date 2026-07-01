$ErrorActionPreference = 'Stop'
if (-not (Test-Path aws-config\config)) { throw 'missing aws config' }
terraform output -raw role_arn | Out-Null
Write-Host 'PASS: aws config and iam role output exist.'
