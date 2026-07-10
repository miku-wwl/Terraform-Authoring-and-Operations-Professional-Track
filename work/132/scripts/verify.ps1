$ErrorActionPreference = 'Stop'

function Read-TerraformOutput([string]$Name) {
  $value = terraform output -raw $Name
  if ($LASTEXITCODE -ne 0) {
    throw "Unable to read Terraform output: $Name"
  }
  return $value.Trim()
}

$accountId = Read-TerraformOutput 'account_id'
$userId = Read-TerraformOutput 'caller_user_id'
$callerArn = Read-TerraformOutput 'caller_arn'
$roleArn = Read-TerraformOutput 'example_role_arn'
$isLocalStack = Read-TerraformOutput 'is_localstack'

if ($accountId -ne '000000000000') {
  throw "Expected LocalStack account 000000000000, got $accountId."
}

if ([string]::IsNullOrWhiteSpace($userId)) {
  throw 'caller_user_id must not be empty.'
}

if ($callerArn -notmatch '^arn:aws:(iam|sts)::000000000000:') {
  throw "Unexpected LocalStack caller ARN: $callerArn"
}

if ($roleArn -ne 'arn:aws:iam::000000000000:role/platform-deployer') {
  throw "example_role_arn was not built from the caller account: $roleArn"
}

if ($isLocalStack -ne 'true') {
  throw "Expected is_localstack=true, got $isLocalStack."
}

Write-Host 'PASS: LocalStack caller identity and derived ARN are correct.'
