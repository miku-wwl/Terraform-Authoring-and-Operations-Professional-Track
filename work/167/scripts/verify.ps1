$ErrorActionPreference = 'Stop'
terraform output -json ingress_rule_count | Out-Null
terraform output -json ingress_rules | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
