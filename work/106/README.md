# 第 106 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/106/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 本节主旨

本节不写 Terraform resource，重点是 AWS CLI 的 profile 配置。

你要练的是：

```text
config       放 region/output 等非敏感配置
credentials 放 access key/secret key 等凭证配置
```

并且用：

```text
AWS_CONFIG_FILE
AWS_SHARED_CREDENTIALS_FILE
```

把 AWS CLI 指向实验目录里的配置文件，避免影响你电脑默认的 AWS 配置。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\106
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
```

## 3. 边学边练

先创建实验专用配置目录：

```powershell
mkdir aws-config
```

创建 `aws-config/config`：

```ini
[profile lab]
region = us-east-1
output = json
```

创建 `aws-config/credentials`：

```ini
[lab]
aws_access_key_id = test
aws_secret_access_key = test
```

注意两个文件里的 profile 写法不同：

```text
config       用 [profile lab]
credentials 用 [lab]
```

然后让当前 PowerShell 使用这两个实验文件：

```powershell
$env:AWS_CONFIG_FILE = "$PWD/aws-config/config"
$env:AWS_SHARED_CREDENTIALS_FILE = "$PWD/aws-config/credentials"
```

手动验证：

```powershell
aws --profile lab --endpoint-url=$env:LOCALSTACK_ENDPOINT sts get-caller-identity
```

## 4. 脚本验收

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- `aws-config/config` 包含 `[profile lab]`、`region = us-east-1`、`output = json`。
- `aws-config/credentials` 包含 `[lab]`、`aws_access_key_id = test`、`aws_secret_access_key = test`。
- `verify.ps1` 会设置 `AWS_CONFIG_FILE` 和 `AWS_SHARED_CREDENTIALS_FILE`，然后用 `--profile lab` 调用 AWS CLI。

## 5. Sandbox / Linux 方式

```sh
export LOCALSTACK_ENDPOINT=http://localhost:4566
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
bash scripts/verify.sh
bash scripts/clean.sh
```

## 6. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```
