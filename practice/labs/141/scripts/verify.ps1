$ErrorActionPreference = 'Stop'
terraform output -raw bucket_name | Out-Null
terraform output -raw bucket_policy | Out-Null
Write-Host 'PASS: s3 bucket and bucket policy outputs exist.'
