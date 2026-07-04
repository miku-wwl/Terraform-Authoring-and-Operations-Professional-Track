# Terraform 实操训练 43：HashiCorp Vault 基础

## 1. 背景

本目录是 `work/43` 上机做题环境，来源于 `practice/43.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：Vault、secret 管理、dev server、state 风险

## 2. 任务目标

Terraform 只记录 Vault 集成契约和 state 风险，不直接读取 secret 原文；Vault CLI smoke test 使用本地 dev server 写入并读取 `secret/db_creds`。

你需要根据题目目标修复起始文件中的 `TODO`，重点练习：

- **TODO 1**：在 `main.tf` 中声明本实验使用 `kv-v2` secret engine
- **TODO 2**：在 `main.tf` 中声明要验证的 Vault secret 路径 `secret/db_creds`
- **TODO 3**：明确 Terraform 不读取 secret 原文，避免 secret 被写入 state
- **TODO 4**：在 `scripts/vault-dev-smoke.sh` 中配置本地 Vault dev server 地址和 token
- **TODO 5**：在 smoke test 中通过 Vault CLI 写入并读取 `secret/db_creds`

注意：Vault 是 secret 管理系统，但 Terraform 一旦通过 provider/data source 读到 secret，值仍可能进入 `terraform.tfstate` 或保存下来的 plan 文件。本实验刻意让 Terraform 只记录 metadata，把 secret 原文读写放到 Vault CLI smoke test 中。

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 配置。
- `input/` 或 `scripts/`：如果存在，是本实验需要的输入或辅助脚本。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/43/`。
- 不要创建真实 AWS 资源。
- Vault 实验只使用本地 dev server，不连接真实 Vault。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

`terraform test` 返回 `1 passed, 0 failed`；Vault CLI smoke test 能启动 dev server，并成功写入/读取 `secret/db_creds`。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个条件、参数或输出。
2. `terraform validate` 失败：先检查 HCL 语法、变量名和输出名是否写错。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。
