$ErrorActionPreference = "Stop"

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = if ($env:AWS_ACCESS_KEY_ID) { $env:AWS_ACCESS_KEY_ID } else { "test" }
$env:AWS_SECRET_ACCESS_KEY = if ($env:AWS_SECRET_ACCESS_KEY) { $env:AWS_SECRET_ACCESS_KEY } else { "test" }
$env:AWS_DEFAULT_REGION = $Region
$env:TF_VAR_localstack_endpoint = $Endpoint

aws --endpoint-url=$Endpoint sts get-caller-identity | Out-Null

foreach ($name in @("tf-lab-ubuntu-2025-01-01-x86_64", "tf-lab-ubuntu-2026-01-01-x86_64")) {
  $exists = aws --endpoint-url=$Endpoint ec2 describe-images `
    --region $Region `
    --owners self `
    --filters "Name=name,Values=$name" `
    --query "Images[].ImageId" `
    --output text 2>$null

  if ([string]::IsNullOrWhiteSpace($exists)) {
    aws --endpoint-url=$Endpoint ec2 register-image `
      --region $Region `
      --name $name `
      --root-device-name /dev/sda1 | Out-Null
  }
}

Write-Host "Lab 34 模拟 AMI 已准备"
