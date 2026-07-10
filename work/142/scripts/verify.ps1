$ErrorActionPreference = 'Stop'
& $PSScriptRoot\check-sandbox.ps1
function Read-Setting([string]$name, [string]$profile) {
  $value = aws configure get $name --profile $profile
  if ($LASTEXITCODE -ne 0) { throw "AWS CLI could not parse $name for $profile." }
  return $value.Trim()
}
if ((Read-Setting 'region' 'base') -ne 'us-east-1') { throw 'base region is incorrect.' }
if ((Read-Setting 'output' 'base') -ne 'json') { throw 'base output is incorrect.' }
if ((Read-Setting 'region' 'lab-142') -ne 'us-east-1') { throw 'lab-142 region is incorrect.' }
if ((Read-Setting 'source_profile' 'lab-142') -ne 'base') { throw 'source_profile must be base.' }
if ((Read-Setting 'role_arn' 'lab-142') -ne 'arn:aws:iam::000000000000:role/tf-pro-lab-142-demo') { throw 'role_arn is incorrect.' }
if ((Read-Setting 'aws_access_key_id' 'base') -ne 'test') { throw 'base access key must be test.' }
if ((Read-Setting 'aws_secret_access_key' 'base') -ne 'test') { throw 'base secret key must be test.' }
$credentials = Get-Content -Raw -Encoding UTF8 $env:AWS_SHARED_CREDENTIALS_FILE
if ($credentials -match '(?im)^\s*\[(?!base\])') { throw 'credentials must contain only [base].' }
if ($credentials -match '(AKIA|ASIA)[A-Z0-9]{12,}') { throw 'A real-looking AWS key was found.' }
Write-Host 'PASS: AWS CLI parsed the isolated source_profile chain without any network call.'
