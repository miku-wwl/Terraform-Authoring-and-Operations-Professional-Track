$ErrorActionPreference = 'Stop'
$name = terraform output -raw iam_user_name
if ($name -ne 'tf-pro-lab-134-operator') { throw "unexpected iam user: $name" }
Write-Host 'PASS: iam user, login profile, and access key exist.'
