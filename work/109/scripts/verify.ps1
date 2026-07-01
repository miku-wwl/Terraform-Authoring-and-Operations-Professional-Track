$ErrorActionPreference = "Stop"
terraform state list | Out-Null
Write-Host "lab 109 verification passed."
