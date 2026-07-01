$ErrorActionPreference = "Stop"

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-east-1" }

$instanceId = terraform output -raw instance_id
$amiId = terraform output -raw selected_ami_id

if ([string]::IsNullOrWhiteSpace($instanceId) -or [string]::IsNullOrWhiteSpace($amiId)) {
  throw "验证失败：instance_id 或 selected_ami_id 为空"
}

$actual = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --instance-ids $instanceId `
  --query "Reservations[].Instances[].ImageId" `
  --output text

if ($actual -notmatch [regex]::Escape($amiId)) {
  throw "验证失败：实例使用的 AMI 与 Terraform 输出不一致"
}

Write-Host "验证通过：实例 $instanceId 使用动态 AMI $amiId"
