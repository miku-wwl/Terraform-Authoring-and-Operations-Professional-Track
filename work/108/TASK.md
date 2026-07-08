# 第 108 节任务

## 背景

AWS CLI Named Profile

## 知识点总结

- named profile 是 AWS CLI 的命名配置，例如 `lab`。
- `--profile lab` 只影响当前这一条 AWS CLI 命令。
- `AWS_PROFILE=lab` 会影响当前 shell 里后续 AWS CLI 命令。
- `config` 文件里 profile 名写作 `[profile lab]`。
- `credentials` 文件里同一个 profile 名写作 `[lab]`。

## 要求

1. 创建名为 lab 的 profile。
2. 使用 --profile lab 调用 AWS CLI。
3. 理解 AWS_PROFILE 环境变量和 --profile 参数的关系。

## Hint

可以直接参考下面的 `aws-config/config`：

```ini
[profile lab]
region = us-east-1
output = json
```

可以直接参考下面的 `aws-config/credentials`：

```ini
[lab]
aws_access_key_id = test
aws_secret_access_key = test
```

单条命令指定 profile：

```powershell
aws --profile lab --endpoint-url=http://localhost:4566 sts get-caller-identity
```

当前 shell 默认使用 profile：

```powershell
$env:AWS_PROFILE = "lab"
aws --endpoint-url=http://localhost:4566 sts get-caller-identity
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/108/`。

## 验收标准

- `aws-config/config` 中存在 `[profile lab]`。
- `aws-config/credentials` 中存在 `[lab]`。
- `aws --profile lab --endpoint-url=http://localhost:4566 sts get-caller-identity` 能成功。
- 设置 `AWS_PROFILE=lab` 后，AWS CLI 不写 `--profile` 也能成功。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
