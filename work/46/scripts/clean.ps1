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

$stateList = terraform state list 2>$null
if ($LASTEXITCODE -eq 0 -and ($stateList -contains "terraform_data.protected_release_marker")) {
  terraform state rm terraform_data.protected_release_marker | Out-Null
}

terraform destroy -auto-approve -input=false

$instanceIds = aws --endpoint-url=$Endpoint ec2 describe-instances `
  --region $Region `
  --filters Name=tag:Project,Values=tf-lab-46 Name=instance-state-name,Values=pending,running,stopping,stopped `
  --query "Reservations[].Instances[].InstanceId" `
  --output text

if (-not [string]::IsNullOrWhiteSpace($instanceIds) -and $instanceIds -ne "None") {
  aws --endpoint-url=$Endpoint ec2 terminate-instances --region $Region --instance-ids $instanceIds.Split() | Out-Null
}

Remove-Item -Path tfplan, ignore-check.txt, replace-check.txt, prevent-destroy-check.txt -ErrorAction SilentlyContinue

Write-Host "clean ok: Terraform-managed resources and residual tf-lab-46 EC2 instances were removed."
