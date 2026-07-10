#!/usr/bin/env sh
set -eu
x="$(terraform output -json launch_template_summary)"
echo "$x"|grep -Fq 'tf-pro-lab-139-web'; echo "$x"|grep -Fq 'ami-12345678'; echo "$x"|grep -Fq 't3.micro'
echo 'PASS: Launch Template summary is correct.'
