# Terraform 实操训练 36：输入变量验证基础

## 1. 背景

本目录是 `work/36` 上机做题环境，来源于 `practice/36.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：输入变量验证、plan 阶段失败、命名约束

## 2. 任务目标

你需要完成 `main.tf` 中的 2 个 TODO，**亲手写两条 validation 规则**：

- **TODO 1**：为 `environment` 变量写白名单验证，只允许 `dev`、`staging`、`prod`
- **TODO 2**：为 `instance_count` 变量写范围验证，限制 1-10

测试文件包含 3 个用例：
- `valid_inputs_pass`：合法输入通过 apply
- `invalid_environment_rejected`：非法 `environment` 在 plan 阶段被拒
- `invalid_instance_count_rejected`：非法 `instance_count` 在 plan 阶段被拒

## 3. 你需要编辑的文件

- `main.tf`：在 `variable "environment"` 和 `variable "instance_count"` 的 validation 块中补齐 `condition` 和 `error_message`。
- `tests/`：已写好正反用例，不要先修改。

## 4. 约束

- 不要修改 `practice/labs/36/`。
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