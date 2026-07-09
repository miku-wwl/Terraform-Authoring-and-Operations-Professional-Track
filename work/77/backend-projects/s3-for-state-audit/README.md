# S3 backend foundation for state audit

这个小项目只创建一个 S3 bucket。

Lab77 的重点是：state 已经进入 S3 backend 后，如何用 Terraform CLI 查看它，而不是手工编辑 state 文件。

它对应的 backend 配置大概是：

```hcl
bucket = "tf-pro-state-localstack"
key    = "labs/77/terraform.tfstate"
region = "us-east-1"
```

执行方式：

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\77\backend-projects\s3-for-state-audit
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
terraform init -input=false
terraform apply -auto-approve
```

注意：这个项目本身用本地 state。它的作用是先把 remote backend 要用的 S3 bucket 创建出来。
