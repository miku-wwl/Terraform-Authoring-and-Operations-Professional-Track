$ErrorActionPreference = 'Stop'
terraform output -json s3_buckets | Out-Null
terraform output -json user_names | Out-Null
terraform output -json sg_id | Out-Null
terraform output -json sg_rule_id | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
