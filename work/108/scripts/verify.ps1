$ErrorActionPreference = "Stop"
$endpoint = if ($env:LOCALSTACK_ENDPOINT) { $env:LOCALSTACK_ENDPOINT } else { "http://localhost:4566" }
$env:AWS_CONFIG_FILE = "$PWD/aws-config/config"
$env:AWS_SHARED_CREDENTIALS_FILE = "$PWD/aws-config/credentials"

# 单条命令指定 profile。
aws --profile lab --endpoint-url=$endpoint sts get-caller-identity | Out-Null

# 当前 shell 默认使用 audit profile。
$env:AWS_PROFILE = "audit"
aws --endpoint-url=$endpoint sts get-caller-identity | Out-Null

# 即使当前 shell 默认是 audit，--profile lab 也能让这一条命令使用 lab。
aws --profile lab --endpoint-url=$endpoint sts get-caller-identity | Out-Null

Write-Host "profile verification passed."
