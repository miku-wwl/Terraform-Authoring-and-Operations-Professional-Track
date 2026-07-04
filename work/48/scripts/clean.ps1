$ErrorActionPreference = "Continue"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

$resourceAddress = "local_file.critical_config"
$configPath = "output/critical-config.txt"

$stateList = terraform state list 2>$null
if ($stateList -contains $resourceAddress) {
  terraform state rm $resourceAddress | Out-Null
}

Remove-Item -LiteralPath $configPath -Force -ErrorAction SilentlyContinue
Remove-Item -Path tfplan, prevent-destroy-check.txt -ErrorAction SilentlyContinue

Write-Host "clean ok: state entry and local protected file were removed if they existed."
