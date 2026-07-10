# 第 141 节任务：S3 Bucket Policy

## 本节主旨

从资源侧为 S3 Bucket 建立访问策略：

```text
LocalStack account principal
          │
          ├─ s3:ListBucket ─► arn:aws:s3:::bucket
          └─ s3:GetObject  ─► arn:aws:s3:::bucket/*
                                      │
                                      ▼
                         aws_s3_bucket_policy.logs
```

## 动手任务

1. 使用 `aws_iam_policy_document` 创建两条 statement。
2. 将 ListBucket 精确绑定到 bucket ARN。
3. 将 GetObject 精确绑定到 object ARN pattern。
4. 两条 statement 都使用明确的 LocalStack account principal，不使用 `Principal="*"`。
5. 使用 `aws_s3_bucket_policy` 绑定 JSON。
6. 输出并验证 Bucket、Policy、Action、Resource 和 Principal。

答案级 Hint 位于 `main.tf` 对应 TODO 旁边。

## 为什么必须拆分 Statement

| Action | Resource 类型 | 示例 |
|---|---|---|
| `s3:ListBucket` | Bucket | `arn:aws:s3:::tf-pro-lab-141-logs` |
| `s3:GetObject` | Object | `arn:aws:s3:::tf-pro-lab-141-logs/*` |

把两个 Action 与两个 Resource 放入同一 statement 会产生四种组合，其中两种 Action-Resource 配对没有正确权限语义。

## Principal 边界

`arn:aws:iam::000000000000:root` 在 account principal 语境中代表 LocalStack 模拟账号，而不是公开访问。真实工程应替换为经过审查的账号、Role 或 Service principal，并评估 S3 Block Public Access、SCP、KMS key policy 等其他控制层。

## 验收标准

- fmt/validate 通过，test 为 `1 passed, 0 failed`。
- apply 创建 Bucket 和 Bucket Policy，共 2 个资源。
- Policy 精确绑定当前 Bucket ID。
- 两条 statement 分别匹配 ListBucket/bucket ARN 与 GetObject/object ARN。
- Principal 不是通配符，而是模拟账号 ARN。
- destroy 先删除 Policy，再删除 Bucket。

## 限制

- 只允许 LocalStack `test/test`、`localhost:4566` 和 S3 endpoint。
- 不上传真实数据，不使用真实 AWS credentials。
- LocalStack 不证明真实跨账号访问或完整 S3 授权链正确。
