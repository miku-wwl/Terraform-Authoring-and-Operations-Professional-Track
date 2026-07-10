# 第 136 节任务：用 aws_iam_policy_document 生成策略

## 本节主旨

使用 HCL statement 构造 IAM JSON，再把生成结果交给真正创建远端对象的 resource：

```text
HCL statement blocks
        │
        ▼
data.aws_iam_policy_document.read_logs
        │ .json（JSON 字符串）
        ▼
aws_iam_policy.read_logs
        │ IAM API
        ▼
LocalStack customer managed policy
```

`aws_iam_policy_document` 是策略构造器，不是现有 IAM Policy 查询器，也不是 managed resource。

## 与 Lab 135 的衔接

Lab 135 使用了：

- `jsonencode(HCL value)`；
- `file("policy.json")`。

本 Lab 使用第三种常见写法：

```hcl
data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["..."]
    resources = ["..."]
  }
}
```

它能通过 Provider schema 检查 `statement`、`actions`、`resources` 等参数，并生成合法 JSON。但是 Action 和 ARN 仍然只是字符串，写成不存在的 AWS Action 不一定会在 `terraform validate` 阶段被发现。

HCL 中 `actions` 和 `resources` 必须使用 list；当 list 只有一个元素时，Provider 可能把最终 JSON 规范化成单个字符串形式的 `"Action"` 和 `"Resource"`。IAM 对单个字符串与单元素数组的解释相同，测试应比较语义而不是假设输出一定保留数组外形。

## 动手任务

1. 创建包含两条 statement 的 `aws_iam_policy_document`。
2. 第一条允许 `logs:DescribeLogGroups`，使用 `Resource = "*"` 并省略 `effect`。
3. 第二条允许 `logs:GetLogEvents`，显式设置 `effect = "Allow"` 并限制到指定 log-stream ARN。
4. 把 `.json` 传给 `aws_iam_policy.read_logs.policy`。
5. 使用 `jsondecode` 输出并检查生成后的 Version、Statement、Action 和 Resource。
6. 运行 Terraform 测试、apply、验证和 destroy。

所有 TODO 的完整答案都紧邻 `main.tf` 中的代码位置。

## 默认 Effect 与自动 Version

第一条 statement 没写：

```hcl
effect = "Allow"
```

生成的 JSON 仍应包含：

```json
"Effect": "Allow"
```

同样，data source 会生成 IAM policy language 的 `Version = "2012-10-17"`。这里的 Version 是策略语言版本，不是 managed policy 的版本编号。

## Action 与 Resource

| Action | 资源级授权 | 本 Lab Resource |
|---|---|---|
| `logs:DescribeLogGroups` | 不支持 | `*` |
| `logs:GetLogEvents` | 支持 log-stream | 指定 Lambda log group 下的 stream ARN pattern |

把两个 Action 随意放进同一条 `Resource = "*"` statement 虽然更短，却会丢失 GetLogEvents 可以收紧的资源范围。

## `.json`、`.minified_json` 与 jsondecode

- `.json`：格式化后的 JSON 字符串，适合阅读和交给 resource。
- `.minified_json`：压缩 JSON 字符串，语义相同。
- `jsondecode(.json)`：把 JSON 转回 Terraform object/list，适合按语义测试，不依赖格式。
- 单元素 `actions/resources` 在解码后可能是 string，而多个元素时会是 list，这是 Provider 的规范化结果。

## 验收标准

- `terraform fmt -check` 和 `terraform validate` 通过。
- `terraform test` 返回 `1 passed, 0 failed`。
- apply 创建 1 个 customer managed policy。
- 生成文档 Version 为 `2012-10-17`，有且仅有两条 statement。
- 省略 effect 的 statement 最终为 `Allow`。
- DescribeLogGroups 使用 `*`；GetLogEvents 使用预期 log-stream ARN。
- `aws_iam_policy.policy` 使用 data source 的 `.json`，不是重复手写 JSON。
- destroy 成功删除 policy。

## LocalStack 边界与限制

- 只允许连接 `http://localhost:4566`。
- 只使用 `test/test` LocalStack 测试凭据。
- 不要使用或写入真实 AWS credentials。
- 本 Lab 不创建 CloudWatch Log Group，也不会调用 Logs API。
- LocalStack 验证 JSON 被 IAM API 接受，不证明真实 AWS 最终授权结果。
- 不要修改 `practice/labs/136/`。
