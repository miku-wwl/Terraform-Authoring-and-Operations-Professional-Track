# 第 45 节做题环境

这是你的上机做题目录。请编辑当前目录下的 Terraform 文件，不要修改 `practice/labs/45/` 中的参考实现。

本实验使用 LocalStack 模拟 AWS EC2 API。Terraform 会创建真实的 `aws_instance` 资源调用，但目标是本地 LocalStack，不是真实 AWS。

## 1. 启动 LocalStack

在仓库根目录打开 PowerShell：

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=ec2,sts `
  localstack/localstack:4.2.0
```

如果容器已经存在：

```powershell
docker ps --filter "name=localstack-tf-labs"
```

## 2. 进入实验目录

```powershell
cd D:\workshop\Codex\Terraform-Authoring-and-Operations-Professional-Track\work\45

$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
```

## 3. 开始做题

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-sandbox.ps1
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1

terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output

powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## 4. 停止 LocalStack

完成练习后，如果后面暂时不做 AWS sandbox lab，可以停止 LocalStack：

```powershell
docker stop localstack-tf-labs
```

## 5. Sandbox / Linux 方式

```sh
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export LOCALSTACK_ENDPOINT=http://localhost:4566
export TF_VAR_localstack_endpoint=http://localhost:4566

bash scripts/check-sandbox.sh
bash scripts/bootstrap.sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
bash scripts/verify.sh
terraform destroy -auto-approve
bash scripts/clean.sh
```

最终验证时会使用 `terraform fmt -check`。
