# Terraform 实操训练 37：密码长度验证

## 1. 背景

本目录是 `work/37` 上机做题环境，来源于 `practice/37.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：`validation`、`length()`、敏感变量

## 2. 任务目标

你需要完成 `main.tf` 中的 3 个 TODO：

- **TODO 1**：将 `db_password` 标记为 `sensitive = true`，防止密码明文泄露
- **TODO 2**：写 `validation` 块，用 `length()` 要求密码 ≥ 12 位
- **TODO 3**：补全 `accepted` 表达式，判断密码是否满足长度要求

测试文件包含 2 个用例：
- `password_policy_passes`：默认密码通过 apply
- `short_password_rejected`：短密码在 plan 阶段被 validation 拦截

## 3. 你需要编辑的文件

- `main.tf`：在 `variable "db_password"` 和 `resource "terraform_data"` 中补齐 TODO。
- `tests/`：已写好正反用例，不要先修改。

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 配置。
- `input/` 或 `scripts/`：如果存在，是本实验需要的输入或辅助脚本。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/37/`。
- 不要创建真实 AWS 资源。
- Vault 实验只使用本地 dev server，不连接真实 Vault。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要把参考实现直接复制进来，先根据测试和题目自己完成。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

`terraform test` 返回 `1 passed, 0 failed`，并能完成本节要求的专项验证。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个条件、参数或输出。
2. `terraform validate` 失败：先检查 HCL 语法、变量名和输出名是否写错。
3. provider 下载失败：重新执行 `terraform init -input=false`。
4. 格式检查失败：运行 `terraform fmt` 后再验证。
5. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。