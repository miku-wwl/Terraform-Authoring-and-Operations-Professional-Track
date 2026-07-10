# Terraform 实操训练 131：迁移 Local State 到 HCP Terraform

## 本节主旨

State migration 只是改变 state 的可信存储位置：

```text
Local terraform.tfstate
        │
        │ terraform init 迁移
        ▼
HCP Terraform Workspace State

真实云资源：保持原样，不应重建
```

本 Lab 只考迁移概念，不连接 HCP Terraform，也不操作任何真实 state。

## 阶段 1：迁移前准备

完成 `main.tf` 的 TODO 1。

生产迁移前应完成：

1. 暂停 CI 和所有可能写入该 state 的 Terraform 操作。
2. 通知相关团队进入迁移窗口。
3. 制作独立 state 备份并安全保存。
4. 记录 Terraform CLI 和 provider versions。
5. 确认目标 organization、workspace 和权限。
6. 如果目标 workspace 已存在，确认它没有 state 和已管理资源。

State 可能包含密码、连接字符串和资源属性，所以备份不能提交 Git 或放入公开 artifact。

## 阶段 2：三个组件的职责

完成 TODO 2。

- `cloud` block：选择 HCP hostname、organization 和 workspace。
- `terraform login`：让本地 CLI 获得访问 HCP Terraform 的 token。
- `terraform init`：重新初始化 backend/cloud integration，并在发现已有 state 时提出迁移。

推荐顺序：

```text
冻结写入 → 备份 → 添加 cloud block → terraform login
→ terraform init 并确认迁移 → 验证远端 state 和 plan
```

迁移 state 不会主动销毁或重建资源。如果迁移后的 plan 显示大规模重建，应停止并调查 target、state 和 provider/configuration 是否一致。

## 阶段 3：Init 参数陷阱

完成 TODO 3。

| 方式 | 行为 |
|---|---|
| `terraform init` | 检测变化并交互式询问是否迁移 |
| `terraform init -migrate-state` | 尝试复制 state，但某些情况仍会询问确认 |
| `terraform init -force-copy` | 自动回答 yes，并隐含 `-migrate-state` |
| `terraform init -reconfigure` | 忽略旧 backend 记录，不迁移已有 state |

因此旧讲义里“`-migrate-state` 就能保证 CI 无交互”的说法不准确。真正抑制迁移确认的是 `-force-copy`，但它也更危险：目标配置错误时会自动复制，所以必须先做审批和校验。

## 阶段 4：迁移后验证

完成 TODO 4。

迁移成功提示出现后仍应检查：

1. HCP Terraform States 页面能看到迁移的 resources 和 state version。
2. `terraform plan` 不应提议意外创建或销毁资源。
3. Workspace variables、environment variables 和 provider authentication 已单独配置。
4. HCP Terraform workspace 的 Terraform version 与本地/迁移版本兼容。
5. 团队权限、state access 和执行模式符合设计。

State migration 不会自动搬运本地 shell credentials、`.tfvars` 或环境变量。

## 关于 `-ignore-remote-version`

该参数用于某些会在本地修改并推送 remote state 的命令。它绕过保护检查，可能生成远端执行版本无法读取的新 state snapshot。

正确顺序是：

1. 优先让 local 和 remote Terraform version 兼容。
2. 查明不一致原因并备份 state。
3. 只有绝对必要、确认兼容并有恢复方案时才使用 `-ignore-remote-version`。

它不是普通迁移命令的默认参数。

## 最终验收

```powershell
terraform fmt
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

## 你现在应该能回答

1. 迁移 state 前为什么必须暂停 CI？
2. `cloud`、`login`、`init` 各自负责什么？
3. `-migrate-state` 是否保证完全无交互？
4. `-force-copy` 和 `-reconfigure` 有什么风险？
5. 迁移后 plan 显示资源全部重建时应该继续吗？

## 官方参考

- [Migrate state to HCP Terraform](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate)
- [Connect the CLI and migrate state](https://developer.hashicorp.com/terraform/cli/cloud/settings)
- [terraform init command](https://developer.hashicorp.com/terraform/cli/commands/init)
- [-ignore-remote-version](https://developer.hashicorp.com/terraform/cli/cloud/command-line-arguments)
