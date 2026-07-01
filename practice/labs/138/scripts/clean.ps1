$ErrorActionPreference = 'Stop'
Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue
Remove-Item -Force .terraform.lock.hcl, tfplan, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host 'Cleaned terraform local files.'
