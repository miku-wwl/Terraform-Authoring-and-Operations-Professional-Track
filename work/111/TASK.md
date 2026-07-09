# 第 111 节任务

## 主题

AWS Provider `default_tags`：在 provider 层统一给资源加默认标签。

## 这节真正要练什么

本节核心不是 S3 bucket，而是 `provider.tf` 里的：

```hcl
default_tags {
  tags = {
    ManagedBy   = "Terraform"
    Environment = "lab"
    Team        = "platform"
  }
}
```

S3 bucket 只是用来验证 provider default tags 是否生效。

## 知识点总结

- `default_tags` 写在 AWS provider 中，对该 provider 管理的资源生效。
- resource 自己的 `tags` 会与 provider 默认标签合并。
- 同名 tag key 冲突时，resource 自己的 `tags` 优先。
- `tags` 表示 resource 显式写的标签。
- `tags_all` 表示 resource 标签和 provider default tags 合并后的最终标签。

## 对照表

| Resource | Resource tags | Final `tags_all` |
| --- | --- | --- |
| `aws_s3_bucket.default` | 无 | `ManagedBy=Terraform`、`Environment=lab`、`Team=platform` |
| `aws_s3_bucket.override` | `Team=network` | `ManagedBy=Terraform`、`Environment=lab`、`Team=network` |

## 要求

1. 在 `provider.tf` 中配置 `default_tags`。
2. 创建一个不写 `tags` 的 S3 bucket，观察它继承默认标签。
3. 创建一个写 `Team = "network"` 的 S3 bucket，观察它覆盖默认 `Team`。
4. 输出两个 bucket 的 `tags_all`。

## Hint

先在 `provider.tf` 中取消注释：

```hcl
default_tags {
  tags = {
    ManagedBy   = "Terraform"
    Environment = "lab"
    Team        = "platform"
  }
}
```

再在 `main.tf` 中取消注释：

```hcl
resource "aws_s3_bucket" "default" {
  bucket = "tf-pro-lab-111-a"
}

resource "aws_s3_bucket" "override" {
  bucket = "tf-pro-lab-111-b"

  tags = {
    Team = "network"
  }
}

output "default_tags" {
  value = aws_s3_bucket.default.tags_all
}

output "override_tags" {
  value = aws_s3_bucket.override.tags_all
}
```

## 限制

- 不要使用真实 AWS。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/111/`。

## 验收标准

- provider 中存在 `default_tags`。
- 默认标签包含 `ManagedBy = "Terraform"`、`Environment = "lab"`、`Team = "platform"`。
- `aws_s3_bucket.default` 不写资源级 `tags`，用来继承默认标签。
- `aws_s3_bucket.override` 写 `Team = "network"`，用来覆盖默认 `Team`。
- `terraform output` 能看到两个资源的 `tags_all`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
