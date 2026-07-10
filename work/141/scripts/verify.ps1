$ErrorActionPreference='Stop'
$r=terraform output -json bucket_policy_relationship|ConvertFrom-Json;$p=terraform output -json bucket_policy_document|ConvertFrom-Json
if($r.bucket_name-ne'tf-pro-lab-141-logs'-or$r.policy_bucket-ne$r.bucket_name){throw 'Bucket policy binding incorrect.'}
$s=@($p.Statement);if($s.Count-ne 2){throw 'Expected two statements.'}
$list=$s|Where-Object{$_.Sid-eq'AllowBucketListing'};$read=$s|Where-Object{$_.Sid-eq'AllowObjectReads'}
if(@($list.Action)-notcontains's3:ListBucket'-or@($list.Resource)-notcontains$r.bucket_arn){throw 'ListBucket scope incorrect.'}
if(@($read.Action)-notcontains's3:GetObject'-or@($read.Resource)-notcontains"$($r.bucket_arn)/*"){throw 'GetObject scope incorrect.'}
if($list.Principal.AWS-ne'arn:aws:iam::000000000000:root'-or$read.Principal.AWS-ne'arn:aws:iam::000000000000:root'){throw 'Principal incorrect.'}
Write-Host 'PASS: Bucket policy binding, principals, actions, and resource scopes are correct.'
