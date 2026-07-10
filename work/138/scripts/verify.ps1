$ErrorActionPreference = 'Stop'
$relationship = terraform output -json attachment_relationship | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read attachment_relationship.' }
$trustService = terraform output -raw trust_service
if ($LASTEXITCODE -ne 0) { throw 'Unable to read trust_service.' }
$permissions = terraform output -json permissions_document | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read permissions_document.' }
if ($relationship.role_name -ne 'tf-pro-lab-138-lambda-role') { throw "Unexpected Role: $($relationship.role_name)" }
if ($relationship.attachment_role -ne $relationship.role_name) { throw 'Attachment targets the wrong Role.' }
if ([string]::IsNullOrWhiteSpace($relationship.managed_policy_arn)) { throw 'Policy ARN is empty.' }
if ($relationship.attachment_policy_arn -ne $relationship.managed_policy_arn) { throw 'Attachment targets the wrong Policy ARN.' }
if ($trustService -ne 'lambda.amazonaws.com') { throw "Unexpected trust service: $trustService" }
$statement = @($permissions.Statement)[0]
if ($statement.Effect -ne 'Allow' -or @($statement.Action) -notcontains 'logs:CreateLogGroup' -or @($statement.Resource) -notcontains '*') { throw 'Permissions policy semantics are incorrect.' }
Write-Host 'PASS: Lambda trust, managed policy semantics, and Role attachment endpoints are correct.'
