# 第 132 节任务：aws_caller_identity 数据源

## 本节主旨

使用 Terraform AWS Provider 查询当前有效 AWS calling identity，并把返回的 Account ID 用在配置表达式中：

```text
LocalStack test/test credentials
           │
           ▼
Terraform AWS Provider
           │ STS GetCallerIdentity
           ▼
aws_caller_identity.current
  ├─ account_id
  ├─ user_id
  └─ arn
```

## Data Source 与 Resource

| Terraform block | 作用 |
|---|---|
| `resource` | 创建、修改和销毁远端对象，并管理其生命周期 |
| `data` | 查询外部信息，供表达式、resource、module 或 output 引用 |

`aws_caller_identity` 只读取 STS 身份，不创建 AWS resource，也没有必填参数。

## 三个关键属性

| 属性 | 含义 |
|---|---|
| `account_id` | 拥有或包含当前 calling entity 的 AWS Account ID |
| `user_id` | calling entity 的唯一标识，不等于 IAM username |
| `arn` | calling entity 的 ARN，可能是 User、Role session 或其他 principal |

## 动手任务

1. 在 `main.tf` 中声明 `data "aws_caller_identity" "current"`。
2. 把 `account_id`、`user_id`、`arn` 放入 `local.caller_identity`。
3. 使用动态 account ID 拼接 `platform-deployer` Role ARN。
4. 判断 account ID 是否为本实验 LocalStack 默认值 `000000000000`。
5. 使用 `terraform test` 验证 STS 查询结果。

每个 TODO 的完整答案都在 `main.tf` 相邻注释中，不需要在 `main.tf` 与本文之间来回找语法。

## 为什么要动态读取 Account ID

不要这样写：

```hcl
role_arn = "arn:aws:iam::123456789012:role/platform-deployer"
```

更可复用的方式是：

```hcl
role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/platform-deployer"
```

同一份配置切换 AWS Account 或 AssumeRole 身份后，可以基于 Provider 的有效身份生成正确 ARN。

## LocalStack 边界

本实验能验证 Terraform → AWS Provider → STS 的查询链路，但不能证明真实 AWS 中的下列内容：

- IAM policy 是否允许某项业务操作；
- SCP 或 permission boundary 是否阻止操作；
- AssumeRole trust policy 是否正确；
- 生产 Account ID、User ID 或 ARN 与模拟值相同。

## 验收标准

- `terraform fmt -check` 通过。
- `terraform validate` 通过。
- `terraform test` 返回 `1 passed, 0 failed`。
- `account_id` 等于 `000000000000`。
- `caller_user_id` 非空。
- `caller_arn` 是 LocalStack 模拟账号下的 IAM 或 STS ARN。
- `example_role_arn` 使用查询结果生成，而不是业务账号硬编码。
- `is_localstack` 为 `true`。

## 限制

- 只允许连接 `http://localhost:4566`。
- 只使用 `test/test` LocalStack 测试凭据。
- 不要写入或使用真实 AWS credentials。
- 不要修改 `practice/labs/132/`。
- 本 Lab 不创建 AWS resource，不需要 `terraform destroy`。
