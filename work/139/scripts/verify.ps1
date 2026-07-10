$ErrorActionPreference='Stop'
$x=terraform output -json launch_template_summary|ConvertFrom-Json
if($x.name-ne'tf-pro-lab-139-web'-or[string]::IsNullOrWhiteSpace($x.id)){throw 'Wrong template identity.'}
if($x.image_id-ne'ami-12345678'-or$x.instance_type-ne't3.micro'){throw 'Wrong launch parameters.'}
if(@($x.security_group_ids).Count-ne 1-or[string]::IsNullOrWhiteSpace(@($x.security_group_ids)[0])){throw 'Expected one Security Group.'}
if([int]$x.latest_version-ne 1-or[int]$x.default_version-ne 1){throw 'Expected initial versions to be 1.'}
if($x.launch_template_tags.Name-ne'tf-pro-lab-139-template'-or$x.future_instance_tags.Name-ne'tf-pro-lab-139-instance'){throw 'Tag layers are incorrect.'}
Write-Host 'PASS: Launch Template identity, parameters, versions, Security Group, and tag layers are correct.'
