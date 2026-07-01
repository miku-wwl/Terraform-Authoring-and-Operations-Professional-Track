$ErrorActionPreference = 'Stop'
$cidr = terraform output -raw first_cidr
if ($cidr -ne '10.132.1.0/24') { throw "unexpected first_cidr: $cidr" }
Write-Host 'PASS: subnet data sources returned expected cidr.'
