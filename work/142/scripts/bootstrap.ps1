$ErrorActionPreference = 'Stop'
$labRoot = Split-Path -Parent $PSScriptRoot
$env:AWS_CONFIG_FILE = Join-Path $labRoot 'aws-config\config'
$env:AWS_SHARED_CREDENTIALS_FILE = Join-Path $labRoot 'aws-config\credentials'
$env:AWS_EC2_METADATA_DISABLED = 'true'
$env:AWS_PROFILE = $null
$env:AWS_DEFAULT_PROFILE = $null
Write-Host 'AWS CLI now uses only the isolated Lab 142 config files.'
