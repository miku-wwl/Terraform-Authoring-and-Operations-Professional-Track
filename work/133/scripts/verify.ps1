$ErrorActionPreference = 'Stop'

$subnetIds = terraform output -json subnet_ids | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read subnet_ids.' }

$subnetCount = [int](terraform output -raw subnet_count)
if ($LASTEXITCODE -ne 0) { throw 'Unable to read subnet_count.' }

$firstSubnet = terraform output -json first_subnet | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Unable to read first_subnet.' }

if ($subnetCount -ne 2 -or $subnetIds.Count -ne 2) {
  throw "Expected exactly two queried subnets, got count=$subnetCount ids=$($subnetIds.Count)."
}

if (($subnetIds | Select-Object -Unique).Count -ne 2) {
  throw 'subnet_ids must contain two unique IDs.'
}

if ($subnetIds -notcontains $firstSubnet.id) {
  throw "Plural query does not contain singular query ID $($firstSubnet.id)."
}

if ($firstSubnet.cidr_block -ne '10.132.1.0/24') {
  throw "Unexpected first subnet CIDR: $($firstSubnet.cidr_block)"
}

if ($firstSubnet.availability_zone -ne 'us-east-1a') {
  throw "Unexpected first subnet AZ: $($firstSubnet.availability_zone)"
}

if ([string]::IsNullOrWhiteSpace($firstSubnet.vpc_id)) {
  throw 'first_subnet.vpc_id must not be empty.'
}

Write-Host 'PASS: plural subnet query and singular subnet details are correct.'
