$ErrorActionPreference='Stop'
$x=terraform output -json asg_spec|ConvertFrom-Json
if($x.name-ne'tf-pro-lab-140-web'-or$x.min_size-ne 1-or$x.desired_capacity-ne 2-or$x.max_size-ne 3){throw 'ASG identity/capacity incorrect.'}
if(@($x.vpc_zone_identifier).Count-ne 2-or(@($x.vpc_zone_identifier)|Select-Object -Unique).Count-ne 2){throw 'Expected two unique subnets.'}
if([string]::IsNullOrWhiteSpace($x.launch_template.id)-or$x.launch_template.version-ne'$Latest'){throw 'Launch Template reference incorrect.'}
if($x.health_check_type-ne'EC2'){throw 'Health check type incorrect.'}
Write-Host 'PASS: ASG model capacity, subnets, health check, and Launch Template reference are correct.'
