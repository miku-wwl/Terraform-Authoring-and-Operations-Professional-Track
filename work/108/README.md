# 第 108 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/108/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- named profile 让你在同一套 AWS config/credentials 文件中保存多套身份配置。
- 本节生成两个 profile：`lab` 和 `audit`。
- 命令行参数 `--profile lab` 会让本次 AWS CLI 调用使用 lab profile。
- 环境变量 `AWS_PROFILE=audit` 会让当前 shell 中后续 AWS CLI 调用默认使用 audit profile。
- 如果同时存在 `--profile` 和 `AWS_PROFILE`，通常以命令行上的 `--profile` 更明确、更适合单条命令。
- 本实验用 `AWS_CONFIG_FILE` 和 `AWS_SHARED_CREDENTIALS_FILE` 指向实验目录中的配置文件，避免污染默认 `~/.aws`。

和第 106 节的区别：

```text
第 106 节：AWS CLI 去哪里读 config/credentials 文件。
第 108 节：读到文件后，AWS CLI 使用哪个 named profile。
```

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,iam,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\108
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
```

## 3. 开始做题

先执行预检。预检脚本会在脚本内部临时使用 LocalStack 的 `test/test` 凭证，不要求你把凭证留在当前 PowerShell 里。

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
```

再生成实验专用 AWS 配置文件：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
```

此时 `aws-config/config` 会包含：

```ini
[profile lab]
region = us-east-1
output = json

[profile audit]
region = us-east-1
output = json
```

`aws-config/credentials` 会包含：

```ini
[lab]
aws_access_key_id = test
aws_secret_access_key = test

[audit]
aws_access_key_id = test
aws_secret_access_key = test
```

手动体会 `--profile`：

```powershell
$env:AWS_CONFIG_FILE = "$PWD/aws-config/config"
$env:AWS_SHARED_CREDENTIALS_FILE = "$PWD/aws-config/credentials"
aws --profile lab --endpoint-url=$env:LOCALSTACK_ENDPOINT sts get-caller-identity
```

手动体会 `AWS_PROFILE`：

```powershell
$env:AWS_PROFILE = "audit"
aws --endpoint-url=$env:LOCALSTACK_ENDPOINT sts get-caller-identity
```

当前 shell 默认是 `audit` 时，单条命令仍然可以显式使用 `lab`：

```powershell
aws --profile lab --endpoint-url=$env:LOCALSTACK_ENDPOINT sts get-caller-identity
```

最后跑脚本验收和清理：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- `aws-config/config` 中存在 `[profile lab]` 和 `[profile audit]`。
- `aws-config/credentials` 中存在 `[lab]` 和 `[audit]`。
- `aws --profile lab ...` 能成功。
- 设置 `AWS_PROFILE=audit` 后，不写 `--profile` 的 AWS CLI 调用也能使用 audit profile。
- 当前 shell 默认是 `audit` 时，显式 `--profile lab` 的单条命令也能成功。

## 4. Sandbox / Linux 方式

```sh
export LOCALSTACK_ENDPOINT=http://localhost:4566
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
bash scripts/verify.sh
bash scripts/clean.sh
```

## 5. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```
