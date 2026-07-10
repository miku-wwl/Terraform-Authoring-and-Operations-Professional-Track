$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = "us-east-1"

$requiredAddresses = @(
  "data.aws_caller_identity.base",
  "data.aws_caller_identity.assumed",
  "aws_s3_bucket.assumed"
)
$state = @(terraform state list)

foreach ($address in $requiredAddresses) {
  if ($address -notin $state) {
    throw "state 中缺少 $address。"
  }
}

$outputs = terraform output -json | ConvertFrom-Json
if ($outputs.bucket_name.value -ne "tf-pro-lab-113") {
  throw "bucket_name 输出不正确。"
}
if ($outputs.identity_comparison.value.changed -ne $true) {
  throw "基础身份和 assumed identity 没有发生变化。"
}
if ($outputs.identity_comparison.value.assumed_arn -notmatch "assumed-role/tf-pro-lab-113") {
  throw "assumed_arn 没有显示 tf-pro-lab-113 临时角色身份。"
}

aws --endpoint-url=$endpoint s3api head-bucket --bucket tf-pro-lab-113
if ($LASTEXITCODE -ne 0) {
  throw "LocalStack 中未找到 tf-pro-lab-113 bucket。"
}

Write-Host "第 113 节验收通过：已观察到 AssumeRole 前后的身份变化。"
