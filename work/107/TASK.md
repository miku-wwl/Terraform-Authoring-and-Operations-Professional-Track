# 第 107 节任务

## 背景

AWS Provider 指定 shared config/credentials 路径

## 知识点总结

- `shared_config_files` 用来指定 AWS config 文件路径。
- `shared_credentials_files` 用来指定 AWS credentials 文件路径。
- `profile = "lab"` 会让 provider 从这些文件中读取 `lab` profile。
- 这和设置全局 `AWS_CONFIG_FILE` 不同：路径写在 Terraform provider 配置里，作用范围更明确。

## 要求

1. 在实验目录创建非默认位置的 AWS config/credentials。
2. 在 provider 中使用 shared_config_files/shared_credentials_files。
3. 创建一个 S3 bucket 验证 provider 能读取这些文件。

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
resource "aws_s3_bucket" "shared_files" {
  bucket = "tf-pro-lab-107"
}

output "bucket_name" {
  value = aws_s3_bucket.shared_files.bucket
}
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/107/`。

## 验收标准

- 实验目录下存在 `aws-config/config` 和 `aws-config/credentials`。
- provider 使用 `profile = "lab"`。
- provider 使用 `shared_config_files` 和 `shared_credentials_files`。
- `terraform output` 能看到 bucket 名称。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
