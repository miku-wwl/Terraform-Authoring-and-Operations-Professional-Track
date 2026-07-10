# 第 113 节任务

## 主题

观察 AWS Provider AssumeRole 前后的身份变化。

Lab112 让你学会写 `assume_role`。Lab113 再向前一步：在同一份 Terraform 配置中保留基础身份，同时创建一个扮演 Role 后的 provider，亲眼比较两者。

## 执行链

```text
默认 aws provider（基础身份）
          |
          | STS AssumeRole
          v
aws.assumed provider（临时身份）
          |
          v
创建 S3 bucket
```

## 动手任务

1. 运行 `scripts/bootstrap.ps1`，在 LocalStack 中创建目标 IAM Role。
2. 在 `provider.tf` 中完成带 `alias = "assumed"` 的 provider。
3. 在 `main.tf` 中用两个 `aws_caller_identity` 分别读取基础身份和临时身份。
4. 为 S3 bucket 指定 `provider = aws.assumed`。
5. 输出两个 ARN，确认 AssumeRole 前后的身份不同。

## Hint

选择 provider 的关键写法：

```hcl
data "aws_caller_identity" "assumed" {
  provider = aws.assumed
}

resource "aws_s3_bucket" "assumed" {
  provider = aws.assumed
  bucket   = "tf-pro-lab-113"
}
```

如果不写 `provider = aws.assumed`，Terraform 会使用默认 provider，也就无法证明这个对象是通过临时身份管理的。

## 验收标准

- `provider.tf` 同时存在默认 `aws` 和 `aws.assumed`。
- `aws.assumed` 中存在 `assume_role` block。
- 两个 `aws_caller_identity` 分别绑定正确的 provider。
- S3 bucket 明确使用 `aws.assumed`。
- `identity_comparison.changed` 为 `true`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 验收通过。

## 限制

- 只使用 LocalStack，不访问真实 AWS。
- 不要把真实 access key 写入实验文件。
- 不要修改 `practice/labs/113/`。
