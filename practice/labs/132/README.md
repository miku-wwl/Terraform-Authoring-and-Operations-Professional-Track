# 第 132 节参考实现：aws_caller_identity 数据源

这个目录是参考答案目录，用于验证题目设计是否可运行。学习或上机时请使用 `work/132/`。

## 本地 LocalStack 验证流程

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\practice\labs\132
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"
$env:TF_VAR_localstack_endpoint="http://localhost:4566"
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
terraform init -input=false
terraform fmt
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```
