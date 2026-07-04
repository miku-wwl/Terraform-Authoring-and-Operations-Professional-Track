# Terraform 实操训练 41：Check block

## 1. 背景

本目录是 `work/41` 上机做题环境，来源于 `practice/41.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：check block、资源外检查、合约验证

## 2. 任务目标

完成 TODO 后，默认 HTTPS 健康检查地址应通过资源外合约验证。

你需要根据题目目标修复起始文件中的 `TODO`，用 `check` block 表达服务 URL 合约：生产服务地址必须使用 `https://`。这个约束不属于某个资源的 `lifecycle`，而是对模块整体输入与输出契约的旁路检查。

本节 TODO 都围绕 `check` block 的资源外合约验证：

- **TODO 1**：补全 `local.service_url_uses_https`，用 `startswith(...)` 表达 HTTPS 合约
- **TODO 2**：在 `check "service_url_contract"` 的 `assert.condition` 中引用这个合约判断

验收时会确认：

- `service_url` 输出以 `https://` 开头
- `service_url_contract_ok` 输出为 `true`
- `check "service_url_contract"` 的断言条件与上述合约一致

## 3. 你需要编辑的文件

- `main.tf`：主要练习文件，包含需要你补齐或修复的 Terraform 配置。
- `input/` 或 `scripts/`：如果存在，是本实验需要的输入或辅助脚本。
- `tests/`：验收测试，建议先不要修改，优先让代码满足测试。

## 4. 约束

- 不要修改 `practice/labs/41/`。
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
