$ErrorActionPreference = "Continue"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:TF_VAR_aws_region) { $env:TF_VAR_aws_region } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = $Region
$env:TF_VAR_localstack_endpoint = $Endpoint

$instanceId = (terraform output -raw web_instance_id).Trim()

if ([string]::IsNullOrWhiteSpace($instanceId)) {
  throw "verify failed: web_instance_id is empty."
}

aws --endpoint-url=$Endpoint ec2 create-tags `
  --region $Region `
  --resources $instanceId `
  --tags Key=Owner,Value=external | Out-Null

$ownerTag = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --instance-ids $instanceId `
  --query "Reservations[].Instances[].Tags[?Key=='Owner'].Value | [0]" `
  --output text

$ownerTag = ([string]$ownerTag).Trim()

if ($ownerTag -ne "external") {
  throw "verify failed: Owner tag drift was not created. Current Owner tag is $ownerTag."
}

$planOutput = terraform plan -input=false -no-color -detailed-exitcode 2>&1 | Out-String
$planExit = $LASTEXITCODE
Set-Content -Path drift-check.txt -Value @(
  "Remote Owner tag after external change: $ownerTag"
  ""
  $planOutput
)

if ($planExit -ne 0) {
  throw "verify failed: Terraform still wants to reconcile the Owner tag drift. See drift-check.txt."
}

Write-Host "verify passed: remote Owner tag is external, and ignore_changes kept Terraform plan clean."
