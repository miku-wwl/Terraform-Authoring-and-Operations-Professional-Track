# S3 backend with DynamoDB lock foundation

这个小项目创建两类资源：

- S3 bucket：保存 Terraform state。
- DynamoDB table：保存旧式 S3 backend locking 需要的锁/摘要记录。

它对应的 backend 配置大概是：

```hcl
bucket         = "tf-pro-state-localstack"
key            = "labs/75/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "tf-pro-lock-localstack"
```

DynamoDB 锁表必须有一个字符串主键：

```hcl
hash_key = "LockID"
```

执行方式：

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\75\backend-projects\s3-with-dynamodb-lock
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
terraform init -input=false
terraform apply -auto-approve
```

注意：这个项目本身用本地 state。它的作用是先把 remote backend 要用的 S3 bucket 和 DynamoDB lock table 创建出来。
