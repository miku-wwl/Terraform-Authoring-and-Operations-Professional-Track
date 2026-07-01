$ErrorActionPreference = "Stop"

$prodId = terraform output -raw production_instance_id
$count = terraform output -raw all_lab_instance_count

if ([string]::IsNullOrWhiteSpace($prodId)) {
  throw "验证失败：生产实例 ID 为空"
}

if ([int]$count -lt 2) {
  throw "验证失败：全部实验实例少于 2 台"
}

Write-Host "验证通过：单实例 $prodId，多实例数量 $count"
