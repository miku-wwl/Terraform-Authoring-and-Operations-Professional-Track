$ErrorActionPreference = "Stop"

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-east-1" }

$count = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --filters "Name=tag:Project,Values=tf-lab-31" `
  --query "length(Reservations[].Instances[])" `
  --output text

$tfCount = terraform output -raw lab_instance_count

if ([int]$count -lt 2) {
  throw "验证失败：LocalStack 中少于 2 台 tf-lab-31 实例"
}

if ([int]$tfCount -lt 2) {
  throw "验证失败：Terraform data source 输出少于 2 台实例"
}

Write-Host "验证通过：data source 读取到 $tfCount 台实例"
