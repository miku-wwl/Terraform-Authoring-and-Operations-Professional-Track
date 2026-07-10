#!/usr/bin/env sh
set -eu

subnet_count="$(terraform output -raw subnet_count)"
first_cidr="$(terraform output -json first_subnet | tr -d '\r\n ' | sed -n 's/.*"cidr_block":"\([^"]*\)".*/\1/p')"
first_az="$(terraform output -json first_subnet | tr -d '\r\n ' | sed -n 's/.*"availability_zone":"\([^"]*\)".*/\1/p')"
first_id="$(terraform output -json first_subnet | tr -d '\r\n ' | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')"
subnet_ids="$(terraform output -json subnet_ids)"

[ "$subnet_count" = '2' ] || {
  echo "Expected subnet_count=2, got $subnet_count." >&2
  exit 1
}

[ "$first_cidr" = '10.132.1.0/24' ] || {
  echo "Unexpected first subnet CIDR: $first_cidr" >&2
  exit 1
}

[ "$first_az" = 'us-east-1a' ] || {
  echo "Unexpected first subnet AZ: $first_az" >&2
  exit 1
}

echo "$subnet_ids" | grep -Fq "$first_id" || {
  echo "Plural query does not contain singular query ID $first_id." >&2
  exit 1
}

echo 'PASS: plural subnet query and singular subnet details are correct.'
