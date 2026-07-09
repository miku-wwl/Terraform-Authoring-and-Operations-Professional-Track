# 第 107 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/107/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- AWS Provider 可以通过 `shared_config_files` 和 `shared_credentials_files` 指定非默认 AWS 配置路径。
- `profile = "lab"` 表示 provider 会从这些文件里读取名为 `lab` 的 profile。
- `config` 文件保存 `[profile lab]` 下的 region/output 等配置。
- `credentials` 文件保存 `[lab]` 下的 access key/secret key。
- 这种写法适合实验、CI 或多账号场景中隔离 AWS 配置来源。
- `aws-config-example/` 是讲解用示例目录，可以提交到 Git。
- `aws-config/` 是脚本生成的运行目录，provider 实际读取它。
- 真实项目不要提交真正的 credentials；本实验只使用 LocalStack 的 `test/test`。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\107
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 开始做题

先阅读示例文件：

```text
aws-config-example/config.example
aws-config-example/credentials.example
```

它们解释了 `config` 和 `credentials` 的典型写法。

然后执行 bootstrap，让当前目录出现 provider 实际读取的文件：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
```

此时会生成：

```text
aws-config/config
aws-config/credentials
```

确认目录出现后，再执行 Terraform：

```powershell
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\clean.ps1
```

验收重点：

- `aws-config-example/` 解释典型配置。
- `aws-config/` 由 `scripts\bootstrap.ps1` 生成。
- `provider "aws"` 中配置了 `profile = "lab"`。
- `shared_config_files` 指向 `${path.module}/aws-config/config`。
- `shared_credentials_files` 指向 `${path.module}/aws-config/credentials`。
- Terraform 能用这个 provider 创建 `tf-pro-lab-107` S3 bucket。

## 4. Sandbox / Linux 方式

```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export LOCALSTACK_ENDPOINT=http://localhost:4566
bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```

## 5. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```
