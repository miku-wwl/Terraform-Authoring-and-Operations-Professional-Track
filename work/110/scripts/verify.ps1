$ErrorActionPreference = "Stop"
terraform state list | Out-Null
Write-Host "第 110 节验收通过。"
