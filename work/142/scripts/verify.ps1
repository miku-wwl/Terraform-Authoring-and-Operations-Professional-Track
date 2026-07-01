$ErrorActionPreference = 'Stop'
if (-not (Test-Path aws-config\config)) { throw 'missing aws-config/config.' }
$content = Get-Content aws-config\config -Raw
if ($content -notmatch 'source_profile = base') { throw 'missing source_profile = base.' }
if ($content -notmatch 'role_arn = arn:aws:iam::000000000000:role/tf-pro-lab-142-demo') { throw 'missing role_arn.' }
Write-Host 'PASS: aws cli source_profile config exists.'
