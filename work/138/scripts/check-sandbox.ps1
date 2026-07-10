$ErrorActionPreference = 'Stop'
$expectedEndpoint = 'http://localhost:4566'
if ($env:LOCALSTACK_ENDPOINT -ne $expectedEndpoint -or $env:TF_VAR_localstack_endpoint -ne $expectedEndpoint) { throw 'Lab 138 only permits http://localhost:4566.' }
if ($env:AWS_ACCESS_KEY_ID -ne 'test' -or $env:AWS_SECRET_ACCESS_KEY -ne 'test') { throw 'Lab 138 requires test/test credentials.' }
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw 'Docker is unavailable.' }
$containerHealth = docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>$null
if ($LASTEXITCODE -ne 0 -or $containerHealth.Trim() -ne 'healthy') { throw "LocalStack is missing or unhealthy: $containerHealth" }
$services = docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs | Where-Object { $_ -like 'SERVICES=*' }
$enabledServices = (($services -replace '^SERVICES=', '') -split ',').Trim()
if ($enabledServices -notcontains 'iam') { throw 'Recreate LocalStack with SERVICES=iam.' }
$health = Invoke-RestMethod -Uri "$expectedEndpoint/_localstack/health" -TimeoutSec 5
if ($health.services.iam -notin @('available', 'running')) { throw "IAM is not ready: $($health.services.iam)" }
Write-Host 'PASS: LocalStack IAM is healthy, endpoint is local, and credentials are test/test.'
