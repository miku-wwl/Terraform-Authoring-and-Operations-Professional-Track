# 第 139 节任务：EC2 Launch Template 基础配置

## 本节主旨

把一组 EC2 启动参数保存为可版本化模板，而不是实际启动实例：

```text
VPC → Security Group ─┐
AMI + instance type ──┼─► aws_launch_template.web ─► future EC2 / ASG
future instance tags ─┘
```

## 动手任务

1. 使用明确的 `name` 创建 Launch Template。
2. 配置 `image_id`、`instance_type` 和 `vpc_security_group_ids`。
3. 使用 `tag_specifications` 设置未来 instance tags。
4. 使用顶层 `tags` 标记 Launch Template 本身。
5. 输出模板 ID、名称、启动参数、两类标签及 latest/default version。
6. 运行 test、apply、验证与 destroy。

完整答案级 Hint 位于 `main.tf` 对应 TODO 旁边。

## 关键边界

| 配置 | 作用对象 |
|---|---|
| 顶层 `tags` | Launch Template |
| `tag_specifications { resource_type = "instance" }` | 将来通过模板创建的 Instance |
| `vpc_security_group_ids` | 将来实例使用的 VPC Security Group |

读取 `tag_specifications` 状态时应按 `resource_type == "instance"` 过滤；Provider 或兼容 API 可能返回额外规范，不能假设整个集合永远只有一个元素。

Launch Template 创建不等于实例启动。AWS 不会在创建模板时完整验证所有参数组合，因此错误 AMI 或不兼容实例类型可能直到真正启动时才失败。

LocalStack 4.2.0 不完整回读 `tag_specifications.tags`，因此本 Lab 用同一个 `local.future_instance_tags` 同时配置模板并输出标签意图；真实 AWS 仍应检查具体模板版本或实际启动结果。

## 版本语义

模板版本不可变。初次创建通常得到版本 1；后续修改模板数据会产生新版本。`latest_version` 与 `default_version` 可能分离，因此后续 ASG 必须明确版本策略。

## 验收标准

- fmt/validate 通过，test 为 `1 passed, 0 failed`。
- apply 创建 VPC、Security Group、Launch Template，共 3 个资源。
- 模板精确保存 AMI、`t3.micro` 和 Terraform 创建的 Security Group ID。
- 模板标签与未来实例标签正确且彼此独立。
- 初始 latest/default version 都为 1。
- destroy 成功清理 3 个资源。

## 限制

- 只允许 `http://localhost:4566` 和 `test/test`。
- 不连接真实 AWS，不创建真实 EC2 instance。
- LocalStack 不证明 AMI 或参数组合可在真实 AWS 启动。
- 不要修改 `practice/labs/139/`。
