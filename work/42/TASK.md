# Terraform 实操训练 42：Sensitive 参数

## 1. 背景

本目录是 `work/42` 上机做题环境，来源于 `practice/42.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：sensitive、敏感输出、state 风险

## 2. 任务目标

模拟 API token 由测试或 CI 注入；Terraform CLI 输出中应隐藏 token 原文，同时仍能输出非敏感派生状态 `token_is_configured = true`。

你需要根据题目目标修复起始文件中的 `TODO`，重点练习三件事：

- **TODO 1**：将输入变量 `api_token` 标记为 `sensitive = true`
- **TODO 2**：用 `nonsensitive(...)` 暴露安全的派生布尔值，而不是输出 token 原文
- **TODO 3**：如果必须输出 token 本身，output 也要显式 `sensitive = true`

注意：`sensitive = true` 只减少 CLI 明文展示，不等于加密。敏感值仍可能进入 `terraform.tfstate` 或保存下来的 plan 文件，所以 state backend、plan 文件和访问权限都要按敏感材料处理。

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 配置。
- `input/` 或 `scripts/`：如果存在，是本实验需要的输入或辅助脚本。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/42/`。
- 不要创建真实 AWS 资源。
- Vault 实验只使用本地 dev server，不连接真实 Vault。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

`terraform test` 返回 `1 passed, 0 failed`，并确认 token 已配置、非敏感状态可见、实验包含 state 风险提醒。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个条件、参数或输出。
2. `terraform validate` 失败：先检查 HCL 语法、变量名和输出名是否写错。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。
