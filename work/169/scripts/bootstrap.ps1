$ErrorActionPreference = 'Stop'
if (-not $env:AWS_ACCESS_KEY_ID) { $env:AWS_ACCESS_KEY_ID = 'test' }
if (-not $env:AWS_SECRET_ACCESS_KEY) { $env:AWS_SECRET_ACCESS_KEY = 'test' }
if (-not $env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION = 'us-east-1' }
if (-not $env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT = 'http://localhost:4566' }
if (-not $env:TF_VAR_localstack_endpoint) { $env:TF_VAR_localstack_endpoint = $env:LOCALSTACK_ENDPOINT }
New-Item -ItemType Directory -Force -Path aws-config | Out-Null
'[profile read-only-access]','region = us-east-1','output = text','role_arn = arn:aws:iam::000000000000:role/tf-pro-169-readonly','source_profile = base','','[profile iam-access]','region = us-east-1','output = text','role_arn = arn:aws:iam::000000000000:role/tf-pro-169-iam','source_profile = base','','[profile ec2-access]','region = us-east-1','output = text','role_arn = arn:aws:iam::000000000000:role/tf-pro-169-ec2','source_profile = base' | Set-Content -Path aws-config\config -Encoding utf8
'[base]','aws_access_key_id = test','aws_secret_access_key = test' | Set-Content -Path aws-config\credentials -Encoding utf8
Write-Host 'Prepared LocalStack env and fake aws config.'
