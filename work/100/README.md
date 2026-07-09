# 第 100 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/100/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 知识点总结

- `provider.tf` 练习定义两个 AWS provider：默认 `aws` 和 alias `aws.prod`。
- root `main.tf` 练习把业务参数 `bucket_names` 和 provider 配置一起传给子模块。
- `modules/buckets/versions.tf` 练习用 `configuration_aliases = [aws.prod]` 声明子模块允许接收 alias provider。
- `modules/buckets/variables.tf` 练习子模块通过变量接收 bucket 名称，而不是写死业务值。
- `modules/buckets/main.tf` 练习 dev bucket 使用默认 provider，prod bucket 使用 `provider = aws.prod`。
- provider 配置由 root module 定义；子模块只接收和使用 provider，不应该在子模块里重新写凭证/endpoint。

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
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\100
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

- `provider.tf` 中有默认 `provider "aws"` 和 `alias = "prod"` 的第二个 provider。
- root module 通过 `bucket_names = local.bucket_names` 给子模块传参。
- root module 通过 `providers` map 把默认 `aws` 和 `aws.prod` 都传入 `modules/buckets`。
- 子模块声明 `configuration_aliases = [aws.prod]`。
- 子模块中一个 bucket 使用默认 provider，另一个 bucket 显式使用 `provider = aws.prod`。
- `terraform output` 能看到两个 bucket 名称。

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
