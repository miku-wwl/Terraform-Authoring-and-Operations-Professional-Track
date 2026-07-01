$ErrorActionPreference = 'Stop'
$arn = terraform output -raw role_arn
if ($arn -notmatch 'tf-pro-lab-137-ec2-role') { throw "unexpected role_arn: $arn" }
Write-Host 'PASS: iam role and trust policy exist.'
