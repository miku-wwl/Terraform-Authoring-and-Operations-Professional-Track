# Terraform 实操训练 116：TF_LOG 与 TF_LOG_PATH 实战

## 1. 背景

本目录是 `work/116` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform debugging 配置建模练习，并亲自运行命令观察 Terraform 日志。

普通的 `terraform plan` 只展示常规结果。排查 Terraform Core、provider 初始化或 graph 构建问题时，可以临时设置：

- `TF_LOG`：控制日志级别。
- `TF_LOG_PATH`：把调试日志写入指定文件，避免大量内容直接输出到终端。

本 lab 不连接任何云账号，也不要求真实基础设施。`terraform_data` 仅提供一个安全的本地 plan 对象。

## 2. 核心主题

- `TF_LOG` 支持 `ERROR`、`WARN`、`INFO`、`DEBUG`、`TRACE`。
- `TRACE` 最详细，正常工作时不应长期启用。
- Windows CMD 使用 `set`。
- Windows PowerShell 使用 `$env:NAME = "value"`。
- Linux 和 macOS 使用 `export`。
- 当前终端设置的环境变量通常只在该会话及其子进程中有效。
- `TF_LOG_PATH` 只负责指定日志文件；仍需同时设置有效的 `TF_LOG`。
- 调试日志可能包含路径、参数、请求上下文甚至敏感数据，不能未经检查直接公开。

## 3. 任务目标

请在 `main.tf` 中完成六个 TODO：

1. 用 `jsondecode(file(...))` 读取 `data/debugging.json`。
2. 从数据中取得按低到高 verbosity 排列的日志级别。
3. 取得最高 verbosity 的日志级别。
4. 构造以 shell 名称为 key 的临时 `TF_LOG` 命令 map。
5. 构造三个 shell 的 `TRACE + TF_LOG_PATH` 命令列表。
6. 构造清理环境变量的命令 map。

完成 Terraform TODO 后，按照 `README.md` 分别尝试：

- 普通 `terraform plan`。
- `TF_LOG=INFO`。
- `TF_LOG=TRACE`。
- `TF_LOG=TRACE` 配合 `TF_LOG_PATH=terraform-debug.log`。
- 清除环境变量后再次运行 plan。

## 4. 验收方式

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

手动确认：

- 设置 `INFO` 后，终端出现额外日志。
- 设置 `TRACE` 后，日志量显著增加。
- 设置 `TF_LOG_PATH` 后，详细日志写入 `terraform-debug.log`。
- 清除环境变量或打开新终端后，不再默认生成该日志文件。

## 5. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `highest_verbosity` 为 `TRACE`。
- `temporary_log_commands` 同时包含 CMD、PowerShell、Linux/macOS 的正确语法。
- `trace_file_commands` 为每种 shell 生成两条命令：设置 `TF_LOG=TRACE` 和设置 `TF_LOG_PATH`。
- `cleanup_commands` 能清除两个调试环境变量。

## 6. 约束

- 不要硬编码输出绕过 `jsondecode()` 和 `for` 表达式。
- JSON 文件路径必须使用 `path.module`。
- 不要在仓库中提交真实调试日志。
- 不要把 access key、secret、token 或其他凭据写入示例。
- 不要把 `TF_LOG=TRACE` 配成全局永久默认值。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
