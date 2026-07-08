# 第 109 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/109/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- AWS Provider 可以通过 `profile = "lab"` 使用 named profile。
- named profile 的具体 region 和 credentials 存在 AWS shared config/credentials 文件中。
- `shared_config_files` 和 `shared_credentials_files` 可以把 provider 限定到实验目录里的配置文件。
- 这样 Terraform 配置不需要直接写 access key，只需要指定使用哪个 profile。
- 本实验用 LocalStack 测试凭证验证 provider 能通过 profile 创建 S3 bucket。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\109
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

- `provider "aws"` 中配置了 `profile = "lab"`。
- provider 使用实验目录中的 `aws-config/config` 和 `aws-config/credentials`。
- Terraform 能创建 `tf-pro-lab-109` S3 bucket。
- `terraform output` 能看到 bucket 名称。

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
