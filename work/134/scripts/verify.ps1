$ErrorActionPreference = 'Stop'

$name = terraform output -raw iam_user_name
if ($LASTEXITCODE -ne 0) { throw 'Unable to read iam_user_name.' }

$resetRequired = terraform output -raw password_reset_required
if ($LASTEXITCODE -ne 0) { throw 'Unable to read password_reset_required.' }

$accessKeyId = terraform output -raw access_key_id
if ($LASTEXITCODE -ne 0) { throw 'Unable to read access_key_id.' }

$accessKeyStatus = terraform output -raw access_key_status
if ($LASTEXITCODE -ne 0) { throw 'Unable to read access_key_status.' }

$accessKeySecret = terraform output -raw access_key_secret
if ($LASTEXITCODE -ne 0) { throw 'Unable to read access_key_secret.' }

$consolePassword = terraform output -raw generated_console_password
if ($LASTEXITCODE -ne 0) { throw 'Unable to read generated_console_password.' }

if ($name -ne 'tf-pro-lab-134-operator') { throw "Unexpected IAM user: $name" }
if ($resetRequired -ne 'true') { throw "Expected password_reset_required=true, got $resetRequired" }
if ([string]::IsNullOrWhiteSpace($accessKeyId)) { throw 'Access Key ID must not be empty.' }
if ($accessKeyStatus -ne 'Active') { throw "Expected Access Key status Active, got $accessKeyStatus" }
if ([string]::IsNullOrWhiteSpace($accessKeySecret)) { throw 'Secret Access Key must not be empty.' }
if ($consolePassword.Length -lt 20) { throw "Generated console password must be at least 20 characters; got $($consolePassword.Length)." }

Write-Host 'PASS: IAM user, login profile, access key, dependency outputs, and secret lengths are correct.'
Write-Host 'Secret values were checked without printing them.'
