$ErrorActionPreference='Stop'
if($env:LOCALSTACK_ENDPOINT-ne'http://localhost:4566'-or$env:AWS_ACCESS_KEY_ID-ne'test'-or$env:AWS_SECRET_ACCESS_KEY-ne'test'){throw 'Unsafe environment.'}
$h=docker inspect --format '{{.State.Health.Status}}' localstack-tf-labs 2>$null;if($LASTEXITCODE-ne 0-or$h.Trim()-ne'healthy'){throw 'LocalStack unhealthy.'}
$s=docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' localstack-tf-labs|Where-Object{$_-like'SERVICES=*'}
if(((($s-replace'^SERVICES=','')-split',').Trim())-notcontains'ec2'){throw 'Recreate with SERVICES=ec2.'}
Write-Host 'PASS: LocalStack EC2 sandbox is safe.'
