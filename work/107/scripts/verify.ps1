$ErrorActionPreference = "Stop"
terraform state list | Out-Null
Write-Host "lab 107 verification passed."
