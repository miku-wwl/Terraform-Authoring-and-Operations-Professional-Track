$ErrorActionPreference = 'Stop'
$labRoot = (Resolve-Path (Split-Path -Parent $PSScriptRoot)).Path
$expectedConfig = Join-Path $labRoot 'aws-config\config'
$expectedCredentials = Join-Path $labRoot 'aws-config\credentials'
if ($env:AWS_CONFIG_FILE -ne $expectedConfig) { throw 'AWS_CONFIG_FILE is not isolated to Lab 142.' }
if ($env:AWS_SHARED_CREDENTIALS_FILE -ne $expectedCredentials) { throw 'AWS_SHARED_CREDENTIALS_FILE is not isolated to Lab 142.' }
if ($env:AWS_EC2_METADATA_DISABLED -ne 'true') { throw 'EC2 metadata lookup must be disabled.' }
if (-not (Get-Command aws -ErrorAction SilentlyContinue)) { throw 'AWS CLI is not installed.' }
Write-Host 'PASS: AWS CLI paths are isolated and metadata lookup is disabled.'
