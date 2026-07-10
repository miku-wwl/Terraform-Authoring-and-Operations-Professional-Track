$ErrorActionPreference = 'Stop'

$expectedEndpoint = 'http://localhost:4566'

if ($env:LOCALSTACK_ENDPOINT -ne $expectedEndpoint) {
  throw "LOCALSTACK_ENDPOINT must be $expectedEndpoint. Refusing to risk a real AWS connection."
}

if ($env:TF_VAR_localstack_endpoint -ne $expectedEndpoint) {
  throw "TF_VAR_localstack_endpoint must be $expectedEndpoint."
}

if ($env:AWS_ACCESS_KEY_ID -ne 'test' -or $env:AWS_SECRET_ACCESS_KEY -ne 'test') {
  throw 'Lab 133 requires LocalStack test/test credentials.'
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  throw 'Docker is not available in PATH.'
}

$containerHealth = docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>$null
if ($LASTEXITCODE -ne 0) {
  throw 'Container localstack-tf-labs does not exist. Start it with the README command.'
}

if ($containerHealth.Trim() -ne 'healthy') {
  throw "Container localstack-tf-labs is not healthy. Current status: $containerHealth"
}

$health = Invoke-RestMethod -Uri "$expectedEndpoint/_localstack/health" -TimeoutSec 5
if ($health.services.ec2 -notin @('available', 'running')) {
  throw "LocalStack EC2 service is not enabled. Current status: $($health.services.ec2). Recreate the container with SERVICES=ec2."
}

Write-Host 'PASS: LocalStack EC2 is healthy, endpoint is local, and credentials are test/test.'
