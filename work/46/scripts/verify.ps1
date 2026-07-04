$ErrorActionPreference = "Continue"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
  $PSNativeCommandUseErrorActionPreference = $false
}

$Endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$Region = if ($env:TF_VAR_aws_region) { $env:TF_VAR_aws_region } else { "us-east-1" }

$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = $Region
$env:TF_VAR_localstack_endpoint = $Endpoint

$instanceId = (terraform output -raw web_instance_id).Trim()

if ([string]::IsNullOrWhiteSpace($instanceId)) {
  throw "verify failed: web_instance_id is empty."
}

$projectTag = ""
for ($attempt = 1; $attempt -le 12; $attempt++) {
  $instanceJsonText = aws --endpoint-url=$Endpoint ec2 describe-instances `
    --region $Region `
    --output json 2>$null | Out-String

  if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($instanceJsonText)) {
    $instanceJson = $instanceJsonText | ConvertFrom-Json
    foreach ($instance in ($instanceJson.Reservations | ForEach-Object { $_.Instances })) {
      $candidateProjectTag = ($instance.Tags | Where-Object { $_.Key -eq "Project" } | Select-Object -First 1).Value
      if ($instance.InstanceId -eq $instanceId -or $candidateProjectTag -eq "tf-lab-46") {
        $instanceId = $instance.InstanceId
        $projectTag = $candidateProjectTag
        break
      }
    }

    if ($null -ne $projectTag) {
      $projectTag = ([string]$projectTag).Trim()
    }
  }

  if ($projectTag -eq "tf-lab-46") {
    break
  }

  Start-Sleep -Seconds 2
}

if ($projectTag -ne "tf-lab-46") {
  throw "verify failed: unexpected Project tag $projectTag."
}

aws --endpoint-url=$Endpoint ec2 create-tags `
  --region $Region `
  --resources $instanceId `
  --tags Key=Owner,Value=external | Out-Null

$ignorePlan = terraform plan -input=false -no-color -detailed-exitcode 2>&1 | Out-String
$ignoreExit = $LASTEXITCODE
Set-Content -Path ignore-check.txt -Value $ignorePlan

if ($ignoreExit -ne 0) {
  throw "verify failed: Owner tag drift was not ignored. See ignore-check.txt."
}

$env:TF_VAR_ami_rollout_generation = "rollout-2"
$replacePlan = terraform plan -input=false -no-color -detailed-exitcode 2>&1 | Out-String
$replaceExit = $LASTEXITCODE
Remove-Item Env:\TF_VAR_ami_rollout_generation -ErrorAction SilentlyContinue
Set-Content -Path replace-check.txt -Value $replacePlan

if ($replaceExit -ne 2) {
  throw "verify failed: rollout generation change did not produce a replacement plan."
}

if ($replacePlan -notmatch "create replacement and then destroy") {
  throw "verify failed: replacement plan did not show create_before_destroy. See replace-check.txt."
}

$destroyOutput = terraform destroy "-target=terraform_data.protected_release_marker" -auto-approve -input=false -no-color 2>&1 | Out-String
$destroyExit = $LASTEXITCODE
Set-Content -Path prevent-destroy-check.txt -Value $destroyOutput

if ($destroyExit -eq 0) {
  throw "verify failed: protected_release_marker was destroyed. prevent_destroy should block it."
}

if ($destroyOutput -notmatch "prevent_destroy|cannot be destroyed|Instance cannot be destroyed") {
  throw "verify failed: destroy failed, but not because of prevent_destroy. See prevent-destroy-check.txt."
}

Write-Host "verify passed: ignore_changes, replace_triggered_by, create_before_destroy, and prevent_destroy all behaved as expected."
