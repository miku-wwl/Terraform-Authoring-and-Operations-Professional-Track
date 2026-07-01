$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { 'http://localhost:4566' }
if ($endpoint -ne 'http://localhost:4566') {
  Write-Warning '当前 endpoint 不是默认 LocalStack 地址，请确认没有连接真实 AWS。'
}
