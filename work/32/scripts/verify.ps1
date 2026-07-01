$ErrorActionPreference = "Stop"

$accountId = terraform output -raw account_id
$region = terraform output -raw current_region

if ($accountId -ne "000000000000") {
  throw "验证失败：账号 ID 不是 LocalStack 默认账号，当前为 $accountId"
}

if ([string]::IsNullOrWhiteSpace($region)) {
  throw "验证失败：region 输出为空"
}

Write-Host "验证通过：当前账号 $accountId，区域 $region"
