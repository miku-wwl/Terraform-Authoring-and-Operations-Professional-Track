# S3-only backend foundation

这个小项目只创建 Terraform S3 backend 需要的 S3 bucket。

它对应的 backend 配置大概是：

```hcl
bucket = "tf-pro-state-localstack"
key    = "labs/74/terraform.tfstate"
region = "us-east-1"
```

执行方式：

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\74\backend-projects\s3-only
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
terraform init -input=false
terraform apply -auto-approve
```

注意：这个项目本身用本地 state。它的作用是先把 remote backend 要用的 S3 bucket 创建出来。
