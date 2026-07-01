$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path aws-config | Out-Null
$config = @(
  '[profile base]',
  'region = us-east-1',
  'output = json',
  '',
  '[profile lab-142]',
  'region = us-east-1',
  'source_profile = base',
  'role_arn = arn:aws:iam::000000000000:role/tf-pro-lab-142-demo'
)
$credentials = @(
  '[base]',
  'aws_access_key_id = test',
  'aws_secret_access_key = test'
)
$config | Set-Content -Path aws-config\config -Encoding utf8
$credentials | Set-Content -Path aws-config\credentials -Encoding utf8
Write-Host 'Created aws-config files.'
