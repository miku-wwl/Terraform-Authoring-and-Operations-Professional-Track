# Terraform 实操训练 124：CLI-driven 步骤与故障定位

## 本节主旨

CLI-driven workflow 的关键不是背命令，而是理解每一步解决哪个问题：

```text
cloud block
→ 去哪个 organization/workspace

terraform login
→ 本地 CLI 以谁的身份访问 HCP Terraform

terraform init
→ 初始化或重新配置 cloud integration

terraform plan/apply
→ 上传本地配置并发起远端 run
```

## 阶段 1：步骤顺序

完成 `main.tf` 的 TODO 1：

```text
配置 cloud target
→ terraform login
→ terraform init
→ terraform plan
→ 审阅后 terraform apply
```

真实环境中，账号/workspace 可能已经存在，登录凭据也可能由自动化注入；但概念依赖仍然是“先有目标和身份，再初始化，最后运行”。

## 阶段 2：职责边界

完成 TODO 2。

- `cloud` block：选择 organization 和 workspace。
- `terraform login`：本地 CLI 获取 HCP Terraform 凭据。
- `terraform init`：初始化或更新 cloud integration。
- `terraform plan`：发起远端 speculative plan。
- `terraform apply`：对非 VCS workspace 发起远端标准 run。

写了 `cloud` block 后仍要执行 `terraform init`。修改 cloud 配置后也应重新 init。

## 阶段 3：常见故障

完成 TODO 3：

| 现象 | 优先检查 |
|---|---|
| 缺少 HCP 凭据 | `terraform login` 或 CLI credentials |
| 连接到错误 workspace | `cloud` block 的 organization/workspace |
| 刚修改 cloud block | 重新运行 `terraform init` |
| 远端 provider 认证失败 | Workspace dynamic provider credentials |
| HCP 中看不到 run | execution mode、目标 workspace 和 run history |

本地电脑能访问 AWS，不代表远端 run 能访问 AWS。

## 阶段 4：Token 安全与远端证据

完成 TODO 4。

- 不提交 `credentials.tfrc.json`。
- 不把 token 写进 `.tf`、变量默认值或测试数据。
- Token 使用短有效期并在不需要时撤销。
- HCP run URL、workspace run history 和 remote execution 设置是直接证据。
- 本地/远端版本不同只是辅助观察；版本相同也可能是远端执行。

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

1. `cloud` block 与 `terraform login` 分别解决什么问题？
2. 修改 `cloud` block 后为什么要重新 init？
3. 本地 AWS 凭据为什么不能解决远端 provider 认证失败？
4. Terraform 版本差异是不是判断远端执行的必要条件？
5. 哪些文件或值绝不能提交 Git？

## 官方参考

- [CLI-driven remote run workflow](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/run/cli)
- [Connect to HCP Terraform](https://developer.hashicorp.com/terraform/cli/cloud/settings)
- [Terraform login](https://developer.hashicorp.com/terraform/cli/commands/login)
