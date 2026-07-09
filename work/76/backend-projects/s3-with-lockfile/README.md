# S3 backend with lockfile foundation

这个小项目只创建一个 S3 bucket。

Lab76 使用的是新式 S3 lockfile：

```hcl
use_lockfile = true
```

所以它不需要 DynamoDB table。state 文件和锁文件都由 S3 backend 在 S3 bucket 中管理。

它对应的 backend 配置大概是：

```hcl
bucket       = "tf-pro-state-localstack"
key          = "labs/76/terraform.tfstate"
region       = "us-east-1"
use_lockfile = true
```

执行方式：

```powershell
cd D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track\work\76\backend-projects\s3-with-lockfile
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
terraform init -input=false
terraform apply -auto-approve
```

注意：这个项目本身用本地 state。它的作用是先把 remote backend 要用的 S3 bucket 创建出来。
