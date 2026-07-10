$ErrorActionPreference = 'Stop'

$summary = terraform output -json policy_summary | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read policy_summary.' }
$document = terraform output -json policy_document | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read policy_document.' }

if ($summary.name -ne 'tf-pro-lab-136-read-logs') { throw "Unexpected policy name: $($summary.name)" }
if ([string]::IsNullOrWhiteSpace($summary.arn)) { throw 'Policy ARN must not be empty.' }
if ($summary.version -ne '2012-10-17') { throw "Unexpected policy Version: $($summary.version)" }
if ([int]$summary.statement_count -ne 2) { throw "Expected two statements, got $($summary.statement_count)" }

$statements = @($document.Statement)
$describe = $statements | Where-Object { $_.Sid -eq 'DescribeLogGroups' }
$read = $statements | Where-Object { $_.Sid -eq 'ReadLogStream' }
if ($describe.Effect -ne 'Allow') { throw 'Omitted effect must render as Allow.' }
if (@($describe.Action) -notcontains 'logs:DescribeLogGroups' -or @($describe.Resource) -notcontains '*') { throw 'DescribeLogGroups statement is incorrect.' }
if ($read.Effect -ne 'Allow' -or @($read.Action) -notcontains 'logs:GetLogEvents') { throw 'ReadLogStream statement is incorrect.' }
$expectedArn = 'arn:aws:logs:us-east-1:*:log-group:/aws/lambda/tf-pro-lab-136:log-stream:*'
if (@($read.Resource) -notcontains $expectedArn) { throw "Unexpected log stream ARN: $($read.Resource)" }

Write-Host 'PASS: policy document defaults, actions, resources, Version, and IAM policy identity are correct.'
