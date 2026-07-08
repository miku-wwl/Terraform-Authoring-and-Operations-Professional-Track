# 第 113 节任务

## 背景

AWS Provider Assume Role 实操

## 知识点总结

- `assume_role` 写在 AWS provider 中。
- Provider 会先调用 STS AssumeRole，再使用临时身份管理资源。
- `role_arn` 是要扮演的角色 ARN，`session_name` 是会话名。
- 本实验用 LocalStack 模拟 STS，不访问真实 AWS。

## 要求

1. 在 provider 中配置 assume_role。
2. 使用 LocalStack STS endpoint。
3. 创建 S3 bucket 验证 provider 已完成 assume role 调用路径。

## Hint

provider 中的关键配置如下：

```hcl
assume_role {
  role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-113"
  session_name = "tf-pro-lab-113"
}
```

可以直接参考下面的资源完成 `main.tf`：

```hcl
resource "aws_s3_bucket" "assumed" {
  bucket = "tf-pro-lab-113"
}

output "bucket_name" {
  value = aws_s3_bucket.assumed.bucket
}
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/113/`。

## 验收标准

- provider 中存在 `assume_role` block。
- provider endpoints 中存在 `sts = var.localstack_endpoint`。
- S3 bucket 通过 assume role provider 创建。
- `terraform output` 能看到 bucket 名称。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
