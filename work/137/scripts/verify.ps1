$ErrorActionPreference = 'Stop'
$identity = terraform output -json role_identity | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read role_identity.' }
$trust = terraform output -json trust_policy_document | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read trust_policy_document.' }
if ($identity.name -ne 'tf-pro-lab-137-ec2-role') { throw "Unexpected role: $($identity.name)" }
if ([string]::IsNullOrWhiteSpace($identity.arn)) { throw 'Role ARN must not be empty.' }
if ($trust.Version -ne '2012-10-17') { throw "Unexpected Version: $($trust.Version)" }
$statements = @($trust.Statement)
if ($statements.Count -ne 1) { throw "Expected one trust statement, got $($statements.Count)" }
$statement = $statements[0]
if ($statement.Sid -ne 'AllowEC2AssumeRole' -or $statement.Effect -ne 'Allow') { throw 'Trust Sid or Effect is incorrect.' }
if (@($statement.Action) -notcontains 'sts:AssumeRole') { throw 'Trust policy must allow sts:AssumeRole.' }
if (@($statement.Principal.Service) -notcontains 'ec2.amazonaws.com') { throw 'Trust policy must name only the EC2 service principal.' }
Write-Host 'PASS: role identity and EC2 trust policy Principal, Action, Effect, Sid, and Version are correct.'
