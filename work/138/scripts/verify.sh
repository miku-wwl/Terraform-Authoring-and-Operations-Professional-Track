#!/usr/bin/env sh
set -eu
relationship="$(terraform output -json attachment_relationship)"
trust="$(terraform output -raw trust_service)"
permissions="$(terraform output -json permissions_document)"
echo "$relationship" | grep -Fq 'tf-pro-lab-138-lambda-role' || { echo 'Wrong Role.' >&2; exit 1; }
[ "$trust" = lambda.amazonaws.com ] || { echo 'Wrong trust service.' >&2; exit 1; }
echo "$permissions" | grep -Fq 'logs:CreateLogGroup' || { echo 'Missing Logs permission.' >&2; exit 1; }
echo 'PASS: Lambda trust, managed policy semantics, and Role attachment endpoints are correct.'
