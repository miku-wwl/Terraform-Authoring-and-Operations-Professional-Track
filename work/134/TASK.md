# 第 134 节任务：IAM 用户、登录配置与访问密钥

## 本节主旨

用三个 Terraform resource 理解一个 IAM User 与两类长期凭据之间的关系：

```text
aws_iam_user.operator
        │ name（同时建立隐式依赖）
        ├──────────────► aws_iam_user_login_profile.operator
        │                  └─ 控制台登录密码
        │
        └──────────────► aws_iam_access_key.operator
                           ├─ Access Key ID
                           └─ Secret Access Key
```

这是一道真实 LocalStack 操作题：你会创建三个 IAM 对象、观察敏感 output 与 state 的边界，然后完整销毁。

## 三个资源分别负责什么

| Terraform resource | 作用 | 是否自动授予权限 |
|---|---|---|
| `aws_iam_user` | 创建 IAM 身份主体 | 否 |
| `aws_iam_user_login_profile` | 为该用户创建控制台登录密码 | 否 |
| `aws_iam_access_key` | 为该用户创建长期 API 凭据 | 否 |

创建凭据不等于授予权限。真实 AWS 中，用户能做什么仍由 identity policy、resource policy、permission boundary、SCP 等共同决定。

## 动手任务

1. 为已有的 `aws_iam_user.operator` 创建 login profile。
2. 设置 `password_length = 20` 和 `password_reset_required = true`。
3. 为同一个用户创建状态为 `Active` 的 access key。
4. 输出用户名、重置要求、Access Key ID 和状态。
5. 输出生成密码和 Secret Access Key，并设置 `sensitive = true`。
6. 使用 `terraform test`、验证脚本和 `terraform destroy` 完成闭环。

每个 TODO 的完整答案都紧邻 `main.tf` 中的代码位置，不需要在两个文件之间来回记语法。

## 为什么必须引用 user resource

推荐：

```hcl
user = aws_iam_user.operator.name
```

这既取得真实用户名，也告诉 Terraform：必须先创建 User，再创建 Login Profile 或 Access Key。

不要在三个资源中分别重复字符串用户名。那样虽然文本相同，却没有 resource reference 建立的依赖边，首次 apply 可能出现并行创建顺序问题。

## sensitive 的真实边界

`sensitive = true` 会让 `terraform output` 和常规 plan/apply 界面隐藏值，但它不是加密机制。Secret Access Key 与未使用 PGP 的生成密码仍保存在 state 中。

因此本实验只在一次性 LocalStack 中创建假凭据。真实工程应保护远端 state 的访问、静态加密、传输加密和审计，并优先使用 IAM Identity Center、IAM Role 与短期凭据。

## 验收标准

- `terraform fmt -check` 通过。
- `terraform validate` 通过。
- `terraform test` 返回 `1 passed, 0 failed`。
- 用户名为 `tf-pro-lab-134-operator`。
- Login Profile 要求首次登录修改密码。
- Access Key 状态为 `Active`，ID 和 Secret 均非空。
- 生成密码长度至少为 20。
- 两个秘密 output 都设置了 `sensitive = true`。
- `terraform destroy` 成功销毁三个资源。

## 限制

- 只允许连接 `http://localhost:4566`。
- 只使用 `test/test` LocalStack 测试凭据。
- 不要使用或写入真实 AWS credentials。
- 不要把本实验生成的假 secret 复制到聊天、日志或代码提交中。
- 不要修改 `practice/labs/134/`。
