# 第 109 节任务

## 背景

AWS Provider 使用 named profile

## 知识点总结

- `profile = "audit"` 让 AWS Provider 使用名为 audit 的 AWS CLI profile。
- profile 的配置来自 `shared_config_files` 和 `shared_credentials_files` 指向的文件。
- Provider 通过 profile 获取凭证，Terraform resource 本身不需要写 access key。
- 和第 107 节不同：第 107 节重点是 shared files 路径，第 109 节重点是多个 profile 里选哪一个。
- 本实验故意让 `lab` 使用 `us-east-1`，让 `audit` 使用 `us-west-2`。
- provider 不写死 `region`，而是通过 `profile = "audit"` 从 config 里读出 `us-west-2`。
- 这适合本地多账号、CI profile 或实验隔离配置。

## 要求

1. 创建 `lab` 和 `audit` 两个 named profile。
2. 在 provider 中配置 `profile = "audit"`。
3. 验证 Terraform 能通过 audit profile 创建资源。
4. 输出 provider 当前 region，确认它来自 audit profile。

## Hint

先看示例目录：

```text
aws-config-example/config.example
aws-config-example/credentials.example
```

再执行脚本生成 provider 实际读取的目录：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
```

provider 的关键配置如下：

```hcl
provider "aws" {
  profile                  = "audit"
  shared_config_files      = ["${path.module}/aws-config/config"]
  shared_credentials_files = ["${path.module}/aws-config/credentials"]
}
```

可以直接参考下面的资源完成 `main.tf`：

```hcl
data "aws_region" "current" {}

resource "aws_s3_bucket" "profile" {
  bucket = "tf-pro-lab-109"
}

output "profile_summary" {
  value = {
    selected_profile = "audit"
    provider_region  = data.aws_region.current.name
    bucket_name      = aws_s3_bucket.profile.bucket
  }
}
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/109/`。

## 验收标准

- 实验目录下存在 `aws-config/config` 和 `aws-config/credentials`。
- provider 使用 `profile = "audit"`。
- `terraform output` 能看到 `provider_region = "us-west-2"`。
- Terraform 能创建 `tf-pro-lab-109` S3 bucket。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
