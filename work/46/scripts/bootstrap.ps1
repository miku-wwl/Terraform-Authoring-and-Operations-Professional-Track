$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:TF_VAR_aws_region) { $env:TF_VAR_aws_region } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = $Region
$env:TF_VAR_localstack_endpoint = $Endpoint

aws --endpoint-url=$Endpoint ec2 describe-instances --region $Region | Out-Null

Write-Host "bootstrap ok: EC2 endpoint is ready. No pre-created resource is required for lab 46."
