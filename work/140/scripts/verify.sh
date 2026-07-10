#!/usr/bin/env sh
set -eu
x="$(terraform output -json asg_spec)";echo "$x"|grep -Fq 'tf-pro-lab-140-web';echo "$x"|grep -Fq '$Latest'
echo 'PASS: ASG model is correct.'
