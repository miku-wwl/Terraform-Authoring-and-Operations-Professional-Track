# Terraform 实操训练 115：Terraform Debugging、TF_LOG 与 TF_LOG_PATH

## 1. 背景

本目录是 `work/115` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform debugging 配置练习。

这个 lab 不会创建真实云资源，而是用 `terraform_data` 和 mock 数据模拟 Terraform debugging 的知识点：

- debugging 的目标是定位 root cause。
- 详细日志可以帮助你理解 Terraform core、provider plugin、plan/apply 流程背后发生了什么。
- `TF_LOG` 控制 Terraform 日志级别。
- `TF_LOG_PATH` 控制详细日志写入文件，避免大量 trace/debug 内容直接输出到终端。

## 2. 核心主题

- `TF_LOG`：启用 Terraform 详细日志。
- `TRACE`、`DEBUG`、`INFO`、`WARN`、`ERROR`：不同 verbosity 的日志级别。
- `TRACE`：最详细，适合深度排查 Terraform core/provider 问题。
- `TF_LOG_PATH`：把日志保存到文件。
- `jsondecode(file(...))`：读取 mock debugging 配置。
- `for` 表达式：从配置中派生命令和检查项。

## 3. 任务目标

请在 `main.tf` 中完成七个 TODO：

1. 用 `jsondecode(file("${path.module}/data/debugging.json"))` 读取并解析 mock 配置。
2. 从解析后的对象中读取 `log_levels` list。
3. 生成 `supported_log_levels`，只保留每个日志级别的 `name`。
4. 找出最详细的日志级别，也就是 verbosity_rank 最小的 level。
5. 构造 `debug_command_bash`，格式为 `TF_LOG=TRACE TF_LOG_PATH=terraform-debug.log terraform plan -input=false -no-color`。
6. 构造 `debug_command_powershell`，格式为 `$env:TF_LOG="TRACE"; $env:TF_LOG_PATH="terraform-debug.log"; terraform plan -input=false -no-color`。
7. 生成 `debugging_checklist`，输出 root cause、verbosity、log file 三个检查项。

完成后运行 `README.md` 中的命令。

## 4. 验收方式

基础检查：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

可选观察输出：

```sh
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 5. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `terraform output supported_log_levels` 显示 `TRACE`、`DEBUG`、`INFO`、`WARN`、`ERROR`。
- `terraform output most_verbose_log_level` 显示 `TRACE`。
- `terraform output debug_command_bash` 显示一条 Linux/macOS shell 命令。
- `terraform output debug_command_powershell` 显示一条 PowerShell 命令。
- `terraform output debugging_checklist` 显示三个调试检查项。

## 6. 约束

- 不要硬编码所有输出绕过 `data/debugging.json`。
- JSON 文件路径必须基于 `path.module` 构造。
- `TF_LOG_PATH` 必须出现在 Bash 和 PowerShell 两条命令里。
- 最详细日志级别必须通过 `verbosity_rank` 计算出来，不要直接写死 `TRACE`。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
