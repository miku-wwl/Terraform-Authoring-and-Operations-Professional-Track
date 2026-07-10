# 第 135 节任务：IAM Managed Policy、Inline Policy 与用户绑定

## 本节主旨

理解两种 identity-based policy 的生命周期，并用 Terraform 把权限文档与 IAM User 正确连接：

```text
                          独立存在、有 ARN、可复用
aws_iam_policy.s3_read ─────────────────────────┐
                                                ▼
aws_iam_user.reader ─────────────────► user_policy_attachment
        │
        └────────────────────────────► aws_iam_user_policy.ec2_describe
                                       隶属于单个 User、无独立 ARN
```

## Managed 与 Inline 的区别

| 特征 | Customer managed policy | Inline policy |
|---|---|---|
| Terraform resource | `aws_iam_policy` | `aws_iam_user_policy` |
| 独立 IAM 对象 | 是 | 否 |
| 独立 ARN | 有 | 无 |
| 可绑定多个身份 | 是 | 否，一对一属于单个身份 |
| 与 User 的连接 | 需要 attachment | `user` 参数直接指定 |
| 删除 User 后 | Policy 可继续存在 | 随身份关系一起删除 |

多数可复用权限适合 managed policy；inline policy 主要用于必须与某个身份保持严格一对一的特殊权限。AWS 当前也建议多数场景优先 managed policy。

## Policy 参数为什么需要 jsonencode

IAM API 接收 JSON 字符串，而下面是 Terraform HCL value：

```hcl
{
  Effect = "Allow"
  Action = ["s3:GetObject"]
}
```

`jsonencode(...)` 会把 HCL object/list 编码成合法 JSON 字符串。相比手写 heredoc JSON，它能减少引号、逗号与转义错误。

本 Lab 同时让 inline policy 使用：

```hcl
file("${path.module}/policies/ec2-describe.json")
```

这代表另一种常见边界：JSON 文件由外部工具或团队流程维护，Terraform 只读取其内容。`${path.module}` 确保路径相对当前 module，而不是依赖运行命令时所在目录。

## 动手任务

1. 使用 `jsonencode` 创建一份 S3 customer managed policy。
2. 为 bucket 与 objects 分别设置正确的 S3 Resource ARN。
3. 使用 `aws_iam_user_policy_attachment` 把 managed policy 绑定到已有 User。
4. 使用 `aws_iam_user_policy` 和 `file()` 创建一份 EC2 Describe inline policy。
5. 输出并解码两份策略文档，验证实际 Action/Resource 和绑定关系。
6. 执行测试、apply、验证和 destroy。

完整答案级 Hint 就在 `main.tf` 对应 TODO 上方。

## 依赖关系

必须使用引用：

```hcl
user       = aws_iam_user.reader.name
policy_arn = aws_iam_policy.s3_read.arn
```

不要手写用户名或拼接 policy ARN。resource reference 不仅提供值，还让 Terraform 得到正确的创建与销毁顺序。

## 权限语义边界

- `s3:ListBucket` 操作 bucket，因此 Resource 是 `arn:aws:s3:::bucket-name`。
- `s3:GetObject` 操作对象，因此 Resource 是 `arn:aws:s3:::bucket-name/*`。
- EC2 多数 Describe 操作没有资源级授权，示例使用 `Resource = "*"`。
- 创建并绑定 policy 不表示最终一定 Allow；显式 Deny、permission boundary、SCP、session policy 等还会参与真实 AWS 的权限评估。

## 验收标准

- `terraform fmt -check` 和 `terraform validate` 通过。
- `terraform test` 返回 `1 passed, 0 failed`。
- apply 创建 User、customer managed policy、attachment 和 inline policy，共 4 个资源。
- managed policy 的 ARN 非空，attachment 同时引用预期 User 与该 ARN。
- managed policy 精确包含 `s3:ListBucket` 与 `s3:GetObject` 及对应资源 ARN。
- inline policy 属于预期 User，并允许 `ec2:DescribeInstances`。
- destroy 成功销毁 4 个资源。

## LocalStack 边界与限制

- 只允许连接 `http://localhost:4566`。
- 只使用 `test/test` LocalStack 测试凭据。
- 不要使用或写入真实 AWS credentials。
- LocalStack 验证的是 Terraform → IAM API 的资源闭环，不证明真实 AWS 权限评估结果。
- 不要修改 `practice/labs/135/`。
