$ErrorActionPreference = "Continue"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

$resourceAddress = "local_file.critical_config"
$configPath = (terraform output -raw critical_config_path).Trim()

if (-not (Test-Path -LiteralPath $configPath)) {
  throw "verify failed: expected protected file at $configPath."
}

$destroyOutput = terraform destroy -auto-approve -input=false -no-color 2>&1 | Out-String
$destroyExit = $LASTEXITCODE
Set-Content -Path prevent-destroy-check.txt -Value $destroyOutput

if ($destroyExit -eq 0) {
  throw "verify failed: terraform destroy succeeded. prevent_destroy should block it."
}

if ($destroyOutput -notmatch "prevent_destroy|cannot be destroyed|Instance cannot be destroyed") {
  throw "verify failed: destroy failed, but not because of prevent_destroy. See prevent-destroy-check.txt."
}

terraform state rm $resourceAddress | Out-Null
if ($LASTEXITCODE -ne 0) {
  throw "verify failed: terraform state rm $resourceAddress failed."
}

Remove-Item -LiteralPath $configPath -Force -ErrorAction SilentlyContinue

if (Test-Path -LiteralPath $configPath) {
  throw "verify failed: protected file still exists after state cleanup."
}

$stateList = terraform state list 2>$null
if ($stateList -contains $resourceAddress) {
  throw "verify failed: $resourceAddress is still in state after terraform state rm."
}

Write-Host "verify passed: prevent_destroy blocked destroy, then state rm detached the file and cleanup removed it."
