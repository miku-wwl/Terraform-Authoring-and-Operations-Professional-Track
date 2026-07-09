# 第 110 节做题环境

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/110/` 中的参考实现。

本实验使用 Docker 启动 LocalStack 来模拟 AWS，Terraform 和 AWS CLI 在本机执行。不要使用真实 AWS 账号。

## 本节主旨

本节练习 provider alias。

你要观察的是：

```text
默认 provider        -> resource/data source 不写 provider 时使用
alias provider aws.usa -> resource/data source 写 provider = aws.usa 时使用
```

本实验故意让两个 provider 使用不同 region：

```text
默认 provider：ap-southeast-1
aws.usa：us-east-1
```

然后用 `data "aws_region"` 输出实际 region，让 alias 是否生效变得可见。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=s3,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在，先确认它是否还在运行：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\110
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 边学边练

先看 `provider.tf`：

```hcl
provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "usa"
  region = "us-east-1"
}
```

然后在 `main.tf` 里完成：

```hcl
data "aws_region" "default" {}

data "aws_region" "usa" {
  provider = aws.usa
}
```

这两个 data source 用来观察两个 provider 的实际 region。

再创建两个 bucket：

```hcl
resource "aws_s3_bucket" "singapore" {
  bucket = "tf-pro-lab-110-a"
}

resource "aws_s3_bucket" "usa" {
  provider = aws.usa
  bucket   = "tf-pro-lab-110-b"
}
```

## 4. 验收命令

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

- `default_region` 应该是 `ap-southeast-1`。
- `usa_region` 应该是 `us-east-1`。
- `aws_s3_bucket.singapore` 使用默认 provider。
- `aws_s3_bucket.usa` 显式使用 `provider = aws.usa`。

## 5. Sandbox / Linux 方式

```sh
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

## 6. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```
