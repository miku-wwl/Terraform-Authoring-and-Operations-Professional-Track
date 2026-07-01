$ErrorActionPreference = 'Stop'
Remove-Item -Recurse -Force .terraform, artifacts, aws-config -ErrorAction SilentlyContinue
Remove-Item -Force .terraform.lock.hcl, tfplan, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host 'Cleaned lab files.'
