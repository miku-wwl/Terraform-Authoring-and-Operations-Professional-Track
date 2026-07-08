# 第 106 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/106/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- AWS CLI 会从 config 文件读取 profile 的 region、output 等非敏感配置。
- AWS CLI 会从 credentials 文件读取 access key、secret key 等凭证配置。
- config 中的命名通常是 `[profile lab]`，credentials 中对应的是 `[lab]`。
- 可以用 `AWS_CONFIG_FILE` 和 `AWS_SHARED_CREDENTIALS_FILE` 指向实验专用文件，避免污染你本机默认 AWS 配置。
- 本实验只使用 LocalStack 的测试凭证 `test/test`，不要写入真实 AWS key。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\106
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 开始做题

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

## 4. Sandbox / Linux 方式

```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
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
