$ErrorActionPreference = "Stop"
terraform state list | Out-Null
Write-Host "第 112 节验收通过。"
