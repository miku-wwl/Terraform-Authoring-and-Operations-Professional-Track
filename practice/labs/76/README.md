# 第 76 节参考实现

本目录演示新式 S3 backend state locking：S3 保存 state，并通过 `use_lockfile = true` 使用 S3 lockfile。

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

`use_lockfile = true` 是新式配置，不再需要 DynamoDB table。新项目应优先掌握这种写法。
