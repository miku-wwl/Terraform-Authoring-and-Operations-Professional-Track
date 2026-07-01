$ErrorActionPreference = 'Stop'
Remove-Item -Recurse -Force aws-config -ErrorAction SilentlyContinue
Write-Host 'Cleaned aws cli config files.'
