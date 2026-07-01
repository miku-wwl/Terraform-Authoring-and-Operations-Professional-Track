# 第 156 节做题环境：挑战一解法三：S3 object 与状态清理

这是你的上机做题目录。请编辑当前目录，不要修改 `practice/labs/156/` 中的参考实现。

## 1. 启动 LocalStack

```powershell
docker run -d --rm --name localstack-tf-labs `
  -p 4566:4566 `
  -p 4510-4559:4510-4559 `
  -e SERVICES=ec2,iam,sts,s3 `
  localstack/localstack:4.2.0
```

理论型 lab 可以不启动 LocalStack。

## 2. 进入实验目录

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\156
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
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```

理论型 lab 只需要执行 bootstrap、verify、clean。

## 4. 清理 LocalStack

```powershell
docker stop localstack-tf-labs
```
