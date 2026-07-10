# 第 138 节任务：IAM Role Policy Attachment

## 本节主旨

把一份独立 managed permissions policy 附加到已有 Lambda Role：

```text
aws_iam_role.lambda                 aws_iam_policy.logs
 role name                                   policy ARN
      └──────────────┐             ┌──────────────┘
                     ▼             ▼
          aws_iam_role_policy_attachment.logs
                     │
                     ▼
       Role 获得该 managed policy 中的权限
```

Lab 137 已经练过 Role trust policy，因此本 Lab 把 Lambda trust/Role 作为 starter，集中练新的 attachment resource。

## 三个对象的职责

| 对象 | 回答的问题 | 能否独立存在 |
|---|---|---|
| Role trust policy | 谁能扮演 Role | 随 Role 存在 |
| Customer managed policy | 定义哪些权限 | 可以，有独立 ARN |
| Role policy attachment | 哪个 Role 使用哪份 managed policy | 依赖 Role 和 Policy |

Managed policy 不能作为 Role trust policy；attachment 加的是 permissions policy。

## 动手任务

1. 创建允许 `logs:CreateLogGroup` 的 customer managed policy。
2. 使用 `aws_iam_role_policy_attachment` 把它绑定到已有 Lambda Role。
3. `role` 必须引用 Role name，`policy_arn` 必须引用 Policy ARN。
4. 输出 attachment 两端、Lambda trust principal 和 permissions document。
5. 运行 test、apply、独立验证和 destroy。

所有 TODO 的完整答案都紧邻 `main.tf` 中的代码位置。

## 为什么必须使用 Resource Reference

```hcl
role       = aws_iam_role.lambda.name
policy_arn = aws_iam_policy.logs.arn
```

这会建立两条依赖边。创建顺序是 Role/Policy 先于 Attachment；销毁顺序则先解除 Attachment，再删除 Role/Policy，避免 `DeleteConflict`。

本题用 `jsonencode` 生成 permissions policy，因此输入的单元素 `Action`/`Resource` list 在解码后仍是 list。Lab 136 的 `aws_iam_policy_document` 可能把单元素集合规范化为 string；两种 JSON 对 IAM 语义等价，但测试时要尊重实际生成方式。

不要手写 Role 名称或拼接 Policy ARN。文本即使碰巧相同，也不会建立 Terraform resource dependency。

## Attachment 资源不要混用

- `aws_iam_role_policy_attachment`：管理 Role 与一份 managed policy 的单条关系，本 Lab 使用它。
- `aws_iam_role_policy`：创建只属于一个 Role 的 inline policy，不是本 Lab 主题。
- `aws_iam_policy_attachment`：跨 Users/Groups/Roles 管理一份 policy 的独占附件集合，通常不应与前者混用。
- `aws_iam_role_policy_attachments_exclusive`：明确接管 Role 的完整 managed policy 集合，语义也不同。

## 验收标准

- `terraform fmt -check`、`terraform validate` 通过。
- `terraform test` 返回 `1 passed, 0 failed`。
- apply 创建 Role、managed policy、attachment，共 3 个 managed resources。
- Role trust principal 为 `lambda.amazonaws.com`。
- attachment 的 Role name 与 Policy ARN 分别等于两个上游资源的值。
- permissions document 允许 `logs:CreateLogGroup`，Effect 为 Allow，Resource 为 `*`。
- destroy 先解除 attachment，再成功删除 Role 和 Policy。

## LocalStack 边界与限制

- 只允许 `http://localhost:4566` 和 `test/test`。
- 不使用或写入真实 AWS credentials。
- 不创建 Lambda Function 或 CloudWatch Log Group。
- LocalStack 不证明 Lambda runtime、iam:PassRole 或真实 IAM policy evaluation 正确。
- 不要修改 `practice/labs/138/`。
