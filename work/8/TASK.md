# Terraform 实操训练 8：`-no-color` 与机器可读日志

## 1. 背景

本目录是 `work/8` 上机做题环境，来源于 `practice/8.md` 的实验设计。这里不是参考答案目录，你需要在当前目录内完成代码或命令练习。

核心主题：`-no-color`、ANSI 控制符、CI 日志归档

## 2. 任务目标

生成 `output/no-color-policy.txt`，测试通过。

本题训练的是 CI/CD 日志可读性：给人看的终端输出可以有颜色，但保存给日志系统、审批系统或机器解析的输出应该禁用颜色控制符。

## 3. 你需要编辑的文件

- `main.tf`：修复 `local.plan_capture_commands` 中不适合 CI/CD 的命令。
- `outputs.tf`：检查 `plan_capture_commands` 和 `policy_file` 输出是否能帮助验证结果。
- `tests/no_color.tftest.hcl`：验收测试，建议不要修改，优先让代码满足测试。

你需要完成两个命令：

- `clean_output`：保存文本 plan 时禁用颜色输出。
- `ci_plan`：在 CI/CD 中禁用交互输入、禁用颜色输出，并保存 plan 文件。

## 4. 约束

- 不要修改 `practice/labs/8/`。
- 不要创建真实 AWS 资源。
- 文档、注释、报告使用中文；命令、参数、文件名可以保留英文。
- 不要改变测试文件来绕过验收。
- 本题重点是 `-no-color`，但 CI/CD 的 plan 命令也应该保留 `-input=false` 和 `-out=tfplan`。

## 5. 验收命令

请先阅读 `README.md` 中的 Docker 命令进入容器，再执行对应验收流程。

## 6. 预期输出

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform apply` 后生成 `output/no-color-policy.txt`。
- `terraform output` 显示 `policy_file = "./output/no-color-policy.txt"`。

## 7. 常见问题

1. `terraform test` 失败：先读断言错误，它通常会指出缺少哪个命令、参数或输出。
2. plan 文本里出现奇怪的 `\u001b` 或 `ESC` 字符：说明没有使用 `-no-color`。
3. CI plan 命令缺少 `-input=false`：流水线可能等待交互输入。
4. CI plan 命令缺少 `-out=tfplan`：后续 apply 不能保证使用同一个已审查 plan。
5. 格式检查失败：运行 `terraform fmt` 后再验证。
6. 想重做实验：删除当前目录下 `.terraform`、`*.tfstate*`、`tfplan`、`plan.json`、`output/` 后重新开始。
