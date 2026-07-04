$ErrorActionPreference = "SilentlyContinue"

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = if ($env:AWS_ACCESS_KEY_ID) { $env:AWS_ACCESS_KEY_ID } else { "test" }
$env:AWS_SECRET_ACCESS_KEY = if ($env:AWS_SECRET_ACCESS_KEY) { $env:AWS_SECRET_ACCESS_KEY } else { "test" }
$env:AWS_DEFAULT_REGION = $Region

$ids = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --filters "Name=tag:Project,Values=tf-lab-45" "Name=instance-state-name,Values=pending,running,stopping,stopped" `
  --query "Reservations[].Instances[].InstanceId" `
  --output text 2>$null

if (-not [string]::IsNullOrWhiteSpace($ids)) {
  aws --endpoint-url=$Endpoint ec2 terminate-instances --region $Region --instance-ids $ids | Out-Null
}

Remove-Item -Force tfplan, replace-check.tfplan, replace-check.txt -ErrorAction SilentlyContinue
Write-Host "Lab45 清理完成。"
