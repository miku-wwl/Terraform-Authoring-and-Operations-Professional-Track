# 第 111 节任务

## 背景

AWS Provider Default Tags

## 知识点总结

- `default_tags` 写在 AWS provider 中，对该 provider 管理的资源生效。
- 资源自己的 `tags` 会与默认标签合并。
- 同名 tag key 冲突时，资源级 `tags` 优先。
- `tags_all` 可以查看合并后的最终标签。

## 要求

1. 在 provider 中配置 default_tags。
2. 创建一个继承默认标签的资源。
3. 创建一个覆盖 Team 标签的资源。

## Hint

可以直接参考下面的资源完成 `main.tf`：

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
- 一个 bucket 不写资源级 tags，用来继承默认标签。
- 一个 bucket 写 `Team = "network"`，用来覆盖默认 Team。
- `terraform output` 能看到两个资源的 `tags_all`。
- `scripts/verify.ps1` 或 `scripts/verify.sh` 通过。
