$ErrorActionPreference = 'Stop'
terraform output -json list_ami | Out-Null
terraform output -json unique_team_names | Out-Null
terraform output -json map_of_maps | Out-Null
Write-Host 'PASS: expected terraform outputs exist.'
