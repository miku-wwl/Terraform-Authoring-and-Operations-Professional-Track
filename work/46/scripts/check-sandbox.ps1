$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:TF_VAR_aws_region) { $env:TF_VAR_aws_region } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = $Region

aws --endpoint-url=$Endpoint sts get-caller-identity --region $Region | Out-Null

Write-Host "sandbox ok: LocalStack STS endpoint is reachable at $Endpoint."
