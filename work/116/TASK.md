# Terraform 实操训练 116：日志去向与会话生命周期

## 本节主旨

Lab 115 已经证明 TRACE 比 INFO 更详细。本节不再重复日志级别比较，而是观察环境变量如何改变日志去向，以及为什么临时会话设置比永久开启 TRACE 更安全。

```text
仅设置 TF_LOG
    → 详细日志写到 stderr，在终端显示

TF_LOG + TF_LOG_PATH
    → 详细日志写入指定文件

清除环境变量
    → 后续 Terraform 命令恢复默认，不再追加详细日志
```

## 阶段 1：让 INFO 日志显示在终端

```powershell
terraform init -input=false
$env:TF_LOG="INFO"
terraform plan -input=false -no-color
Remove-Item Env:TF_LOG
```

没有设置 `TF_LOG_PATH`，所以详细日志写到 stderr，并与正常 plan 输出一起显示在终端。

## 阶段 2：让 TRACE 日志写入文件

```powershell
Remove-Item terraform-debug.log -ErrorAction SilentlyContinue
$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="terraform-debug.log"
terraform plan -input=false -no-color
$beforeCleanup = (Get-Item terraform-debug.log).Length
```

打开 `terraform-debug.log`，搜索 `[TRACE]`。此时不要立即清除变量，因为下一阶段需要比较清理前后的文件大小。

## 阶段 3：清除变量并验证日志停止追加

```powershell
Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
terraform plan -input=false -no-color
$afterCleanup = (Get-Item terraform-debug.log).Length
$beforeCleanup -eq $afterCleanup
```

预期返回 `True`。这说明清除环境变量以后，普通 plan 没有继续向日志文件追加内容。

再检查：

```powershell
Test-Path Env:TF_LOG
Test-Path Env:TF_LOG_PATH
```

两条都应返回 `False`。

这种 `$env:` 设置属于当前 PowerShell 进程的环境变量，Terraform 作为其子进程会继承它。关闭当前终端后，设置也会消失。

## 阶段 4：验收

```powershell
terraform fmt
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

测试会读取真实的 `terraform-debug.log`，确认它包含 TRACE 日志。文件大小在清理后是否停止变化，由阶段 3 的 PowerShell 比较直接验证。

## 跨平台参考

Windows CMD：

```bat
set TF_LOG=TRACE
set TF_LOG_PATH=terraform-debug.log
terraform plan -input=false -no-color
set TF_LOG=
set TF_LOG_PATH=
```

Linux/macOS：

```bash
export TF_LOG=TRACE
export TF_LOG_PATH=terraform-debug.log
terraform plan -input=false -no-color
unset TF_LOG
unset TF_LOG_PATH
```

## 安全与清理

- 不要把 TRACE 永久配置为系统环境变量。
- 日志文件会追加内容，每次复现实验前先删除旧文件。
- Debug log 可能包含敏感上下文，分享前必须检查和脱敏。
- 如果中途退出步骤，使用下面的命令清理：

```powershell
Remove-Item Env:TF_LOG -ErrorAction SilentlyContinue
Remove-Item Env:TF_LOG_PATH -ErrorAction SilentlyContinue
```

## 你现在应该能回答

1. 只设置 `TF_LOG` 时，详细日志输出到哪里？
2. `TF_LOG_PATH` 能否单独开启日志？
3. 为什么 Terraform 能看到 PowerShell 中设置的 `$env:TF_LOG`？
4. 怎样证明清除变量后日志不再追加？
5. 为什么不应该永久开启 TRACE？
