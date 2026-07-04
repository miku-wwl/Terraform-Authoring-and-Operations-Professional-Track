$ErrorActionPreference = "Continue"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

$planOutput = terraform plan "-var=image_version=v2" -input=false -no-color -detailed-exitcode 2>&1 | Out-String
$planExit = $LASTEXITCODE
Set-Content -Path replace-check.txt -Value $planOutput

if ($planExit -ne 2) {
  throw "verify failed: image_version=v2 did not create a replacement plan. See replace-check.txt."
}

if ($planOutput -notmatch "must be replaced") {
  throw "verify failed: plan did not say terraform_data.service_release must be replaced. See replace-check.txt."
}

if ($planOutput -notmatch "create replacement and then destroy") {
  throw "verify failed: plan did not show create_before_destroy order. See replace-check.txt."
}

Write-Host "verify passed: triggers_replace caused replacement, and create_before_destroy changed replacement order."
