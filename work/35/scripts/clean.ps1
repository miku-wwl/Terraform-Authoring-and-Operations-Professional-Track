$ErrorActionPreference = "Stop"

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-east-1" }

$ids = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --filters "Name=tag:Project,Values=tf-lab-35" `
  --query "Reservations[].Instances[].InstanceId" `
  --output text 2>$null

if (-not [string]::IsNullOrWhiteSpace($ids)) {
  aws --endpoint-url=$Endpoint ec2 terminate-instances --region $Region --instance-ids ($ids -split "\s+") | Out-Null
}

$images = aws --endpoint-url=$Endpoint ec2 describe-images `
  --region $Region `
  --owners self `
  --filters "Name=name,Values=tf-lab-app-*-x86_64" `
  --query "Images[].ImageId" `
  --output text 2>$null

if (-not [string]::IsNullOrWhiteSpace($images)) {
  foreach ($image in ($images -split "\s+")) {
    if ($image) {
      aws --endpoint-url=$Endpoint ec2 deregister-image --region $Region --image-id $image | Out-Null
    }
  }
}

Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue
Remove-Item -Force .terraform.lock.hcl, tfplan, terraform.tfstate, terraform.tfstate.backup -ErrorAction SilentlyContinue
Write-Host "Lab 35 清理完成"
