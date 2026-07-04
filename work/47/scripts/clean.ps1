$ErrorActionPreference = "Continue"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

terraform destroy -auto-approve -input=false
Remove-Item -Path tfplan, replace-check.txt -ErrorAction SilentlyContinue

Write-Host "clean ok: lab 47 state was destroyed."
