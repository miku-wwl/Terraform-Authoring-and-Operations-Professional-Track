$ErrorActionPreference = 'Stop'

$expectedEndpoint = 'http://localhost:4566'

if ($env:LOCALSTACK_ENDPOINT -ne $expectedEndpoint) {
  throw "LOCALSTACK_ENDPOINT must be $expectedEndpoint. Refusing to risk a real AWS connection."
}

if ($env:TF_VAR_localstack_endpoint -ne $expectedEndpoint) {
  throw "TF_VAR_localstack_endpoint must be $expectedEndpoint."
}

if ($env:AWS_ACCESS_KEY_ID -ne 'test' -or $env:AWS_SECRET_ACCESS_KEY -ne 'test') {
  throw 'Lab 132 requires LocalStack test/test credentials.'
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  throw 'Docker is not available in PATH.'
}

$health = docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>$null
if ($LASTEXITCODE -ne 0) {
  throw 'Container localstack-tf-labs does not exist. Start it with the README command.'
}

if ($health.Trim() -ne 'healthy') {
  throw "Container localstack-tf-labs is not healthy. Current status: $health"
}

$response = Invoke-WebRequest -UseBasicParsing -Uri "$expectedEndpoint/_localstack/health" -TimeoutSec 5
if ($response.StatusCode -ne 200) {
  throw "LocalStack health endpoint returned HTTP $($response.StatusCode)."
}

Write-Host 'PASS: LocalStack is healthy, endpoint is local, and credentials are test/test.'
