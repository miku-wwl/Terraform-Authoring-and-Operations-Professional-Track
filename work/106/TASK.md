# 第 106 节任务

## 主题

AWS CLI profile：把 `config` 和 `credentials` 拆开管理，并让本实验使用独立 AWS 配置文件。

## 这节要解决的问题

平时 AWS CLI 默认会读你电脑上的：

```text
~/.aws/config
~/.aws/credentials
```

但做实验时不希望污染本机真实配置，也不希望误用真实 AWS key。

所以本节练习自己创建一套实验专用文件：

```text
aws-config/config
aws-config/credentials
```

然后用环境变量让 AWS CLI 只读这套实验配置。

## 知识点总结

- `config` 保存非敏感配置，例如 `region`、`output`。
- `credentials` 保存凭证配置，例如 `aws_access_key_id`、`aws_secret_access_key`。
- `config` 里的 profile 写法是 `[profile lab]`。
- `credentials` 里的同一个 profile 写法是 `[lab]`。
- `AWS_CONFIG_FILE` 指向本次实验使用的 config 文件。
- `AWS_SHARED_CREDENTIALS_FILE` 指向本次实验使用的 credentials 文件。
- `--profile lab` 表示本次 AWS CLI 命令使用名为 `lab` 的 profile。

## 练习目标

1. 创建 `aws-config/config`。
2. 创建 `aws-config/credentials`。
3. 设置 `AWS_CONFIG_FILE` 和 `AWS_SHARED_CREDENTIALS_FILE`。
4. 使用 `--profile lab` 调用 LocalStack STS。

## Hint

第一步：创建目录。

```powershell
mkdir aws-config
```

第二步：创建 `aws-config/config`。

```ini
[profile lab]
region = us-east-1
output = json
```

第三步：创建 `aws-config/credentials`。

```ini
[lab]
aws_access_key_id = test
aws_secret_access_key = test
```

第四步：让当前 PowerShell 使用实验专用配置文件。

```powershell
$env:AWS_CONFIG_FILE = "$PWD/aws-config/config"
$env:AWS_SHARED_CREDENTIALS_FILE = "$PWD/aws-config/credentials"
$env:LOCALSTACK_ENDPOINT = "http://localhost:4566"
```

第五步：用 profile 验证。

```powershell
aws --profile lab --endpoint-url=$env:LOCALSTACK_ENDPOINT sts get-caller-identity
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/106/`。

## 验收标准

- `aws-config/config` 中存在 `[profile lab]`。
- `aws-config/config` 中存在 `region = us-east-1` 和 `output = json`。
- `aws-config/credentials` 中存在 `[lab]`。
- `aws-config/credentials` 中存在 `aws_access_key_id = test` 和 `aws_secret_access_key = test`。
- `aws --profile lab --endpoint-url=http://localhost:4566 sts get-caller-identity` 能成功。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
