# 第 106 节任务

## 背景

AWS CLI config 与 credentials 文件

## 知识点总结

- `config` 保存 profile 的非敏感配置，例如 region 和 output。
- `credentials` 保存 profile 的凭证配置，例如 access key 和 secret key。
- `config` 里的 profile 名要写成 `[profile lab]`。
- `credentials` 里的同一个 profile 名要写成 `[lab]`。
- `AWS_CONFIG_FILE` 和 `AWS_SHARED_CREDENTIALS_FILE` 可以让本实验使用独立配置文件，不影响你本机默认 AWS 配置。

## 要求

1. 创建独立的 config 和 credentials 文件。
2. 确认 config 保存 region/output，credentials 保存 key。
3. 使用 AWS_CONFIG_FILE 和 AWS_SHARED_CREDENTIALS_FILE 指向实验文件。

## Hint

可以直接参考下面的内容创建 `aws-config/config`：

```ini
[profile lab]
region = us-east-1
output = json
```

可以直接参考下面的内容创建 `aws-config/credentials`：

```ini
[lab]
aws_access_key_id = test
aws_secret_access_key = test
```

PowerShell 中可以这样指向实验专用文件：

```powershell
$env:AWS_CONFIG_FILE = "$PWD/aws-config/config"
$env:AWS_SHARED_CREDENTIALS_FILE = "$PWD/aws-config/credentials"
aws --profile lab --endpoint-url=$env:LOCALSTACK_ENDPOINT sts get-caller-identity
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/106/`。

## 验收标准

- `aws-config/config` 中存在 `[profile lab]`。
- `aws-config/credentials` 中存在 `[lab]`。
- `aws --profile lab --endpoint-url=http://localhost:4566 sts get-caller-identity` 能成功。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
