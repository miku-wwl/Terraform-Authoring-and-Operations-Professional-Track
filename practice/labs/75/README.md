# 第 75 节参考实现

本目录演示旧式 S3 backend state locking：S3 保存 state，DynamoDB table 保存锁信息。

## 本地验证

```powershell
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
$env:LOCALSTACK_ENDPOINT="http://localhost:4566"

powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
terraform init -input=false -backend-config=backend.hcl
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform state list
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
terraform destroy -auto-approve
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## 重点

`dynamodb_table` 是旧式配置。Terraform 1.14 会提示 deprecated，但很多老系统仍然使用它。
