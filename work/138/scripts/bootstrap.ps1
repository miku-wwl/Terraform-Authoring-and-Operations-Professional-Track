$ErrorActionPreference = 'Stop'
$env:AWS_ACCESS_KEY_ID = 'test'
$env:AWS_SECRET_ACCESS_KEY = 'test'
$env:AWS_SESSION_TOKEN = $null
$env:AWS_PROFILE = $null
$env:AWS_DEFAULT_REGION = 'us-east-1'
$env:AWS_REGION = 'us-east-1'
$env:LOCALSTACK_ENDPOINT = 'http://localhost:4566'
$env:TF_VAR_localstack_endpoint = $env:LOCALSTACK_ENDPOINT
$env:TF_VAR_aws_region = $env:AWS_DEFAULT_REGION
Write-Host 'Prepared LocalStack test/test credentials in the current PowerShell process.'
