$ErrorActionPreference = "Stop"
terraform state list | Out-Null
Write-Host "第 100 节验收通过。"
