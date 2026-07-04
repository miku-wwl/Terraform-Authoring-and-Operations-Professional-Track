$ErrorActionPreference = "Stop"

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = if ($env:AWS_ACCESS_KEY_ID) { $env:AWS_ACCESS_KEY_ID } else { "test" }
$env:AWS_SECRET_ACCESS_KEY = if ($env:AWS_SECRET_ACCESS_KEY) { $env:AWS_SECRET_ACCESS_KEY } else { "test" }
$env:AWS_DEFAULT_REGION = $Region
$env:TF_VAR_localstack_endpoint = $Endpoint

$outputs = terraform output -json | ConvertFrom-Json
$instanceId = $outputs.instance_ids.value.web

if ([string]::IsNullOrWhiteSpace($instanceId)) {
  throw "verify failed: instance_ids.web is empty."
}

$imageId = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --instance-ids $instanceId `
  --query "Reservations[].Instances[].ImageId" `
  --output text

$instanceType = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --instance-ids $instanceId `
  --query "Reservations[].Instances[].InstanceType" `
  --output text

$nameTag = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --instance-ids $instanceId `
  --query "Reservations[].Instances[].Tags[?Key=='Name'].Value | [0]" `
  --output text

if ($imageId -ne "ami-0123456789abcdef0") {
  throw "verify failed: unexpected AMI $imageId."
}

if ($instanceType -ne "t3.micro") {
  throw "verify failed: unexpected instance type $instanceType."
}

if ($nameTag -ne "tf-lab-45-web") {
  throw "verify failed: unexpected Name tag $nameTag."
}

$env:TF_VAR_ami_rollout_generation = "rollout-2"
$planOutput = terraform plan -input=false -no-color 2>&1 | Out-String
Remove-Item Env:\TF_VAR_ami_rollout_generation -ErrorAction SilentlyContinue
Set-Content -Path replace-check.txt -Value $planOutput

if ($LASTEXITCODE -ne 0) {
  throw "verify failed: replacement plan failed."
}

if ($planOutput -notmatch "create replacement and then destroy") {
  throw "verify failed: replacement plan did not show create_before_destroy."
}

Write-Host "verify passed: LocalStack EC2 exists, attributes are correct, replacement plan shows create_before_destroy."
