# 第 109 节任务

## 背景

AWS Provider 使用 named profile

## 知识点总结

- `profile = "lab"` 让 AWS Provider 使用名为 lab 的 AWS CLI profile。
- profile 的配置来自 `shared_config_files` 和 `shared_credentials_files` 指向的文件。
- Provider 通过 profile 获取凭证，Terraform resource 本身不需要写 access key。
- 这适合本地多账号、CI profile 或实验隔离配置。

## 要求

1. 创建 named profile。
2. 在 provider 中配置 profile。
3. 验证 Terraform 能通过 profile 创建资源。

## Hint

provider 的关键配置如下：

```hcl
provider "aws" {
  region                   = "us-east-1"
  profile                  = "lab"
  shared_config_files      = ["${path.module}/aws-config/config"]
  shared_credentials_files = ["${path.module}/aws-config/credentials"]
}
```

可以直接参考下面的资源完成 `main.tf`：

```hcl
resource "aws_s3_bucket" "profile" {
  bucket = "tf-pro-lab-109"
}

output "bucket_name" {
  value = aws_s3_bucket.profile.bucket
}
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/109/`。

## 验收标准

- 实验目录下存在 `aws-config/config` 和 `aws-config/credentials`。
- provider 使用 `profile = "lab"`。
- Terraform 能创建 `tf-pro-lab-109` S3 bucket。
- `terraform output` 能看到 bucket 名称。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
