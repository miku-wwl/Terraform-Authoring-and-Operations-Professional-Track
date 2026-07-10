# 第 137 节任务：IAM Role 与 AssumeRole 信任策略

## 本节主旨

创建一个只信任 EC2 服务主体的 IAM Role，并清楚区分两条授权边界：

```text
Trust policy                           Permissions policy
“谁能成为这个 Role？”                  “成为 Role 后能做什么？”

ec2.amazonaws.com                     S3 / EC2 / Logs actions
        │ sts:AssumeRole                       │
        ▼                                      ▼
  aws_iam_role.ec2                  本 Lab 故意不创建
```

Role 没有 trust policy 就不能正常建立信任；Role 没有 permissions policy 仍可以被创建，但成功扮演后没有本 Lab 授予的业务权限。

## Trust Policy 四个关键元素

| JSON 元素 | 本 Lab 值 | 含义 |
|---|---|---|
| `Effect` | `Allow` | 允许满足 statement 的请求 |
| `Action` | `sts:AssumeRole` | 建立 Role session |
| `Principal.Service` | `ec2.amazonaws.com` | 可信主体是 EC2 服务 |
| `Sid` | `AllowEC2AssumeRole` | 可读的 statement 标识 |

Trust policy 是 Role 上的 resource-based policy，因此存在 `Principal`。普通附着到 Role 的 identity-based permissions policy 通常不写 Principal。

## 动手任务

1. 用 `aws_iam_policy_document` 生成 EC2 trust policy。
2. 使用 `principals { type = "Service" }` 表达服务主体。
3. 创建 `aws_iam_role`，把 `.json` 传给 `assume_role_policy`。
4. 输出 Role name/ARN，并解码 Role 实际保存的 trust policy。
5. 运行测试、apply、独立验证和 destroy。

完整答案级 Hint 位于 `main.tf` 对应 TODO 旁边。

## 不要混淆的三个动作

- `sts:AssumeRole`：可信主体获得 Role session 临时凭据。
- `iam:PassRole`：某个人或自动化把一个 Role 交给 EC2 等 AWS 服务使用。
- Role permissions：Role session 使用临时凭据后可以调用哪些业务 API。

本 Lab 只练第一项 trust relationship。它不创建 EC2 instance、Instance Profile 或 permissions policy。

## 为什么不能使用通配 Principal

下面的信任边界过宽：

```json
"Principal": "*"
```

服务角色应指定预期 service principal。本题只允许 `ec2.amazonaws.com`，不会顺便信任 Lambda、任意账号或匿名主体。

## 验收标准

- `terraform fmt -check` 和 `terraform validate` 通过。
- `terraform test` 返回 `1 passed, 0 failed`。
- apply 只创建 1 个 IAM Role。
- Role 名称为 `tf-pro-lab-137-ec2-role`，ARN 非空。
- trust policy Version 为 `2012-10-17`。
- 唯一 statement 精确包含 `Allow`、`sts:AssumeRole` 和 `Service=ec2.amazonaws.com`。
- 配置没有 permissions policy attachment，避免误认为 trust policy 会授予业务权限。
- destroy 成功删除 Role。

## LocalStack 边界与限制

- 只允许连接 `http://localhost:4566`。
- 只使用 `test/test` LocalStack 测试凭据。
- 不要使用或写入真实 AWS credentials。
- LocalStack 只验证 Role/trust policy API 闭环，不证明真实 EC2、Instance Profile、PassRole 或临时凭据流程。
- 不要修改 `practice/labs/137/`。
