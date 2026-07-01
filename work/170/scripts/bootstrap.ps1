$ErrorActionPreference = 'Stop'
if (-not $env:AWS_ACCESS_KEY_ID) { $env:AWS_ACCESS_KEY_ID = 'test' }
if (-not $env:AWS_SECRET_ACCESS_KEY) { $env:AWS_SECRET_ACCESS_KEY = 'test' }
if (-not $env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION = 'us-east-1' }
if (-not $env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT = 'http://localhost:4566' }
if (-not $env:TF_VAR_localstack_endpoint) { $env:TF_VAR_localstack_endpoint = $env:LOCALSTACK_ENDPOINT }
Write-Host "LocalStack endpoint: $env:LOCALSTACK_ENDPOINT"
