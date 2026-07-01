$ErrorActionPreference = 'Stop'
terraform output -raw launch_template_id | Out-Null
$spec = terraform output -json asg_spec
if ($spec -notmatch 'tf-pro-lab-140-web') { throw 'asg_spec does not contain expected name.' }
Write-Host 'PASS: launch template exists and ASG spec is modeled for LocalStack-limited practice.'
