#!/usr/bin/env sh
set -eu

summary="$(terraform output -json policy_summary)"
document="$(terraform output -json policy_document)"

echo "$summary" | grep -Fq 'tf-pro-lab-136-read-logs' || { echo 'Unexpected policy name.' >&2; exit 1; }
echo "$summary" | grep -Fq '"statement_count":2' || { echo 'Expected two statements.' >&2; exit 1; }
echo "$document" | grep -Fq '"Version":"2012-10-17"' || { echo 'Unexpected policy Version.' >&2; exit 1; }
echo "$document" | grep -Fq 'logs:DescribeLogGroups' || { echo 'Missing DescribeLogGroups.' >&2; exit 1; }
echo "$document" | grep -Fq 'logs:GetLogEvents' || { echo 'Missing GetLogEvents.' >&2; exit 1; }
echo "$document" | grep -Fq 'arn:aws:logs:us-east-1:*:log-group:/aws/lambda/tf-pro-lab-136:log-stream:*' || { echo 'Missing scoped log-stream ARN.' >&2; exit 1; }

echo 'PASS: policy document defaults, actions, resources, Version, and IAM policy identity are correct.'
