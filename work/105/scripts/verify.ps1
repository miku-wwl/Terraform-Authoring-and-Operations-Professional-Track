$ErrorActionPreference = "Stop"
terraform state list | Out-Null
Write-Host "第 105 节验收通过。"
