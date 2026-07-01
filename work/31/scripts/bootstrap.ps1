$ErrorActionPreference = "Stop"

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = if ($env:AWS_ACCESS_KEY_ID) { $env:AWS_ACCESS_KEY_ID } else { "test" }
$env:AWS_SECRET_ACCESS_KEY = if ($env:AWS_SECRET_ACCESS_KEY) { $env:AWS_SECRET_ACCESS_KEY } else { "test" }
$env:AWS_DEFAULT_REGION = $Region
$env:TF_VAR_localstack_endpoint = $Endpoint

aws --endpoint-url=$Endpoint sts get-caller-identity | Out-Null

$existing = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --filters "Name=tag:Project,Values=tf-lab-31" `
  --query "Reservations[].Instances[].InstanceId" `
  --output text

if ([string]::IsNullOrWhiteSpace($existing)) {
  aws --endpoint-url=$Endpoint ec2 run-instances `
    --region $Region `
    --image-id ami-tf-lab-31 `
    --instance-type t3.micro `
    --count 2 `
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=tf-lab-31-source},{Key=Project,Value=tf-lab-31}]" | Out-Null
}

Write-Host "Lab 31 前置 EC2 已准备"
