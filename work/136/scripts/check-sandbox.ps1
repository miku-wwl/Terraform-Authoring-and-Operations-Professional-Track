$ErrorActionPreference = 'Stop'

$expectedEndpoint = 'http://localhost:4566'
if ($env:LOCALSTACK_ENDPOINT -ne $expectedEndpoint) { throw "LOCALSTACK_ENDPOINT must be $expectedEndpoint. Refusing real AWS access." }
if ($env:TF_VAR_localstack_endpoint -ne $expectedEndpoint) { throw "TF_VAR_localstack_endpoint must be $expectedEndpoint." }
if ($env:AWS_ACCESS_KEY_ID -ne 'test' -or $env:AWS_SECRET_ACCESS_KEY -ne 'test') { throw 'Lab 136 requires test/test credentials.' }
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw 'Docker is not available in PATH.' }

$containerHealth = docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>$null
if ($LASTEXITCODE -ne 0) { throw 'Container localstack-tf-labs does not exist.' }
if ($containerHealth.Trim() -ne 'healthy') { throw "LocalStack is not healthy: $containerHealth" }

$services = docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs | Where-Object { $_ -like 'SERVICES=*' }
$enabledServices = (($services -replace '^SERVICES=', '') -split ',').Trim()
if ($enabledServices -notcontains 'iam') { throw 'Recreate LocalStack with SERVICES=iam.' }

$health = Invoke-RestMethod -Uri "$expectedEndpoint/_localstack/health" -TimeoutSec 5
if ($health.services.iam -notin @('available', 'running')) { throw "IAM is not ready: $($health.services.iam)" }

Write-Host 'PASS: LocalStack IAM is healthy, endpoint is local, and credentials are test/test.'
