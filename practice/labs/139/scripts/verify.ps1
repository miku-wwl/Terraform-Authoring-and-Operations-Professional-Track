$ErrorActionPreference = 'Stop'
terraform output -raw launch_template_id | Out-Null
Write-Host 'PASS: launch template exists.'
