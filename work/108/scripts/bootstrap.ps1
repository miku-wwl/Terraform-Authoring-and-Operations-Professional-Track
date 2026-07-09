$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force aws-config | Out-Null
Set-Content -Encoding ASCII aws-config/config -Value @(
  "[profile lab]",
  "region = us-east-1",
  "output = json",
  "",
  "[profile audit]",
  "region = us-east-1",
  "output = text"
)
Set-Content -Encoding ASCII aws-config/credentials -Value @(
  "[lab]",
  "aws_access_key_id = test",
  "aws_secret_access_key = test",
  "",
  "[audit]",
  "aws_access_key_id = test",
  "aws_secret_access_key = test"
)
Write-Host "AWS lab config files created."
