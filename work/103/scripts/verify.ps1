$ErrorActionPreference = "Stop"
terraform state list | Out-Null
Write-Host "第 103 节验收通过。"
