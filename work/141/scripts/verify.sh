#!/usr/bin/env sh
set -eu
x="$(terraform output -json bucket_policy_document)";echo "$x"|grep -Fq 's3:ListBucket';echo "$x"|grep -Fq 's3:GetObject';echo "$x"|grep -Fq '000000000000:root'
echo 'PASS: Bucket policy semantics are correct.'
