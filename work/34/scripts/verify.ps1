$ErrorActionPreference = "Stop"

$amiId = terraform output -raw latest_ami_id
$amiName = terraform output -raw latest_ami_name

if ([string]::IsNullOrWhiteSpace($amiId)) {
  throw "验证失败：AMI ID 为空"
}

if ($amiName -notlike "tf-lab-ubuntu-*") {
  throw "验证失败：AMI 名称不符合预期：$amiName"
}

Write-Host "验证通过：最新模拟 AMI 为 $amiName ($amiId)"
