#!/usr/bin/env sh
set -eu
identity="$(terraform output -json role_identity)"
trust="$(terraform output -json trust_policy_document)"
echo "$identity" | grep -Fq 'tf-pro-lab-137-ec2-role' || { echo 'Unexpected role name.' >&2; exit 1; }
echo "$trust" | grep -Fq '2012-10-17' || { echo 'Unexpected Version.' >&2; exit 1; }
echo "$trust" | grep -Fq 'AllowEC2AssumeRole' || { echo 'Missing Sid.' >&2; exit 1; }
echo "$trust" | grep -Fq 'sts:AssumeRole' || { echo 'Missing AssumeRole.' >&2; exit 1; }
echo "$trust" | grep -Fq 'ec2.amazonaws.com' || { echo 'Missing EC2 principal.' >&2; exit 1; }
echo 'PASS: role identity and EC2 trust policy semantics are correct.'
