$ErrorActionPreference = 'Stop'

$relationships = terraform output -json policy_relationships | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read policy_relationships.' }

$managed = terraform output -json managed_policy_document | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read managed_policy_document.' }

$inline = terraform output -json inline_policy_document | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read inline_policy_document.' }

if ($relationships.user_name -ne 'tf-pro-lab-135-reader') { throw "Unexpected user: $($relationships.user_name)" }
if ($relationships.attached_user -ne $relationships.user_name) { throw 'Managed policy attachment targets the wrong user.' }
if ([string]::IsNullOrWhiteSpace($relationships.managed_policy_arn)) { throw 'Managed policy ARN must not be empty.' }
if ($relationships.attached_policy_arn -ne $relationships.managed_policy_arn) { throw 'Attachment does not reference the managed policy ARN.' }
if ($relationships.inline_policy_owner -ne $relationships.user_name) { throw 'Inline policy belongs to the wrong user.' }
if ($relationships.inline_policy_name -ne 'tf-pro-lab-135-ec2-describe') { throw "Unexpected inline policy name: $($relationships.inline_policy_name)" }

$managedStatements = @($managed.Statement)
$listStatement = $managedStatements | Where-Object { $_.Sid -eq 'ListBucket' }
$readStatement = $managedStatements | Where-Object { $_.Sid -eq 'ReadObjects' }
if (@($listStatement.Action) -notcontains 's3:ListBucket') { throw 'Managed policy must allow s3:ListBucket.' }
if (@($listStatement.Resource) -notcontains 'arn:aws:s3:::tf-pro-lab-135-shared') { throw 'ListBucket must target the bucket ARN.' }
if (@($readStatement.Action) -notcontains 's3:GetObject') { throw 'Managed policy must allow s3:GetObject.' }
if (@($readStatement.Resource) -notcontains 'arn:aws:s3:::tf-pro-lab-135-shared/*') { throw 'GetObject must target the object ARN pattern.' }

$inlineStatement = @($inline.Statement)[0]
if (@($inlineStatement.Action) -notcontains 'ec2:DescribeInstances') { throw 'Inline policy must allow ec2:DescribeInstances.' }
if ($inlineStatement.Resource -ne '*') { throw 'The EC2 Describe statement must use Resource="*".' }

Write-Host 'PASS: managed policy, attachment, inline policy, actions, and resource scopes are correct.'
