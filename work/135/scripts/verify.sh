#!/usr/bin/env sh
set -eu

relationships="$(terraform output -json policy_relationships)"
managed="$(terraform output -json managed_policy_document)"
inline="$(terraform output -json inline_policy_document)"

echo "$relationships" | grep -Fq 'tf-pro-lab-135-reader' || {
  echo 'Expected user relationship was not found.' >&2
  exit 1
}
echo "$relationships" | grep -Fq 'tf-pro-lab-135-ec2-describe' || {
  echo 'Expected inline policy relationship was not found.' >&2
  exit 1
}
echo "$managed" | grep -Fq 's3:ListBucket' || { echo 'Managed policy is missing s3:ListBucket.' >&2; exit 1; }
echo "$managed" | grep -Fq 'arn:aws:s3:::tf-pro-lab-135-shared' || { echo 'Managed policy is missing the bucket ARN.' >&2; exit 1; }
echo "$managed" | grep -Fq 's3:GetObject' || { echo 'Managed policy is missing s3:GetObject.' >&2; exit 1; }
echo "$managed" | grep -Fq 'arn:aws:s3:::tf-pro-lab-135-shared/*' || { echo 'Managed policy is missing the object ARN.' >&2; exit 1; }
echo "$inline" | grep -Fq 'ec2:DescribeInstances' || { echo 'Inline policy is missing ec2:DescribeInstances.' >&2; exit 1; }

echo 'PASS: managed policy, attachment, inline policy, actions, and resource scopes are correct.'
