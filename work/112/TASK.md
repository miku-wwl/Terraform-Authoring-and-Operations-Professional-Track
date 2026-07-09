# 第 112 节任务

## 主题

AWS Provider `assume_role`：让 provider 先扮演一个角色，再用临时身份管理资源。

## 这节真正要练什么

本节核心在 `provider.tf`：

```hcl
assume_role {
  role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-112"
  session_name = "tf-pro-lab-112"
}
```

你要理解的是：

```text
Terraform 基础凭证
  -> AWS STS AssumeRole
  -> 临时凭证
  -> 创建 S3 bucket
```

`aws_s3_bucket` 只是验证工具，不是本节重点。

## 知识点总结

- `assume_role` 写在 AWS provider 中。
- Provider 会先用基础凭证调用 STS AssumeRole。
- AssumeRole 成功后，provider 使用临时身份创建和管理资源。
- `role_arn` 表示要扮演哪个角色。
- `session_name` 表示这次临时会话的名字。
- resource 本身不需要知道 assume role 细节。
- 真实 AWS 中常用于跨账号部署、CI/CD 临时授权和权限边界隔离。

## 要求

1. 在 `provider.tf` 中配置 `assume_role`。
2. 确认 provider endpoints 中配置了 `sts = var.localstack_endpoint`。
3. 在 `main.tf` 中创建 S3 bucket。
4. 输出 bucket 名称。

## Hint

provider 中的关键配置如下：

```hcl
assume_role {
  role_arn     = "arn:aws:iam::000000000000:role/tf-pro-lab-112"
  session_name = "tf-pro-lab-112"
}
```

`main.tf` 可以参考：

```hcl
resource "aws_s3_bucket" "assumed" {
  bucket = "tf-pro-lab-112"
}

output "bucket_name" {
  value = aws_s3_bucket.assumed.bucket
}
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/112/`。

## 验收标准

- provider 中存在 `assume_role` block。
- provider endpoints 中存在 `sts = var.localstack_endpoint`。
- S3 bucket 通过这个 provider 创建。
- `terraform output` 能看到 bucket 名称。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
