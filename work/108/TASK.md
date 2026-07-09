# 第 108 节任务

## 背景

AWS CLI Named Profile

第 106 节已经解决了“AWS CLI 去哪里读配置文件”。

本节解决另一个问题：配置文件里有多套 profile 时，AWS CLI 这次到底使用哪一套。

## 知识点总结

- named profile 是 AWS CLI 的命名配置，例如 `lab`、`audit`。
- `--profile lab` 只影响当前这一条 AWS CLI 命令。
- `AWS_PROFILE=audit` 会影响当前 shell 里后续 AWS CLI 命令。
- 如果同时设置了 `AWS_PROFILE=audit`，但命令里写了 `--profile lab`，这一条命令会使用 `lab`。
- `config` 文件里 profile 名写作 `[profile lab]`。
- `credentials` 文件里同一个 profile 名写作 `[lab]`。

## 要求

1. 创建名为 `lab` 和 `audit` 的两个 profile。
2. 使用 `--profile lab` 调用 AWS CLI。
3. 使用 `AWS_PROFILE=audit` 设置当前 shell 默认 profile。
4. 理解 `--profile` 对单条命令的优先级更明确。

## Hint

`scripts/bootstrap.ps1` 会生成下面的 `aws-config/config`：

```ini
[profile lab]
region = us-east-1
output = json

[profile audit]
region = us-east-1
output = json
```

同时生成下面的 `aws-config/credentials`：

```ini
[lab]
aws_access_key_id = test
aws_secret_access_key = test

[audit]
aws_access_key_id = test
aws_secret_access_key = test
```

先让 AWS CLI 使用实验目录里的配置文件：

```powershell
$env:AWS_CONFIG_FILE = "$PWD/aws-config/config"
$env:AWS_SHARED_CREDENTIALS_FILE = "$PWD/aws-config/credentials"
```

单条命令指定 profile：

```powershell
aws --profile lab --endpoint-url=http://localhost:4566 sts get-caller-identity
```

当前 shell 默认使用 profile：

```powershell
$env:AWS_PROFILE = "audit"
aws --endpoint-url=http://localhost:4566 sts get-caller-identity
```

当前 shell 默认是 `audit` 时，单条命令仍然可以显式使用 `lab`：

```powershell
aws --profile lab --endpoint-url=http://localhost:4566 sts get-caller-identity
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/108/`。

## 验收标准

- `aws-config/config` 中存在 `[profile lab]` 和 `[profile audit]`。
- `aws-config/credentials` 中存在 `[lab]` 和 `[audit]`。
- `aws --profile lab --endpoint-url=http://localhost:4566 sts get-caller-identity` 能成功。
- 设置 `AWS_PROFILE=audit` 后，AWS CLI 不写 `--profile` 也能成功。
- 设置 `AWS_PROFILE=audit` 后，显式 `--profile lab` 也能成功。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
