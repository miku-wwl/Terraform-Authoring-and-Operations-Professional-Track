# Terraform 实操训练 115：TF_LOG 与 TF_LOG_PATH

## 本节主旨

Terraform 默认只显示正常的命令结果。遇到异常行为时，可以临时启用详细日志，观察 Terraform core、provider 和执行图背后的信息，从而定位 root cause。

两个核心环境变量：

```text
TF_LOG      = 是否启用日志，以及使用哪个详细级别
TF_LOG_PATH = 把已经启用的日志保存到哪个文件
```

只设置 `TF_LOG_PATH` 不会启用日志。Terraform 日志默认写到 stderr；同时设置 `TF_LOG_PATH` 后，日志会保存到指定文件。已有日志文件会被追加，因此每轮练习前先删除旧文件。

## 阶段 1：建立正常输出基线

```powershell
terraform init -input=false
terraform plan -input=false -no-color
```

先观察正常 plan 输出。调试的第一步不是立刻开启最大日志，而是知道正常行为是什么，并能稳定复现问题。

## 阶段 2：生成 INFO 日志

```powershell
Remove-Item terraform-info.log -ErrorAction SilentlyContinue
$env:TF_LOG="INFO"
$env:TF_LOG_PATH="terraform-info.log"
terraform plan -input=false -no-color
Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
```

打开 `terraform-info.log`，搜索 `[INFO]`。INFO 适合先了解 Terraform 版本、backend 和主要执行阶段。

## 阶段 3：生成 TRACE 日志并比较

```powershell
Remove-Item terraform-trace.log -ErrorAction SilentlyContinue
$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="terraform-trace.log"
terraform plan -input=false -no-color
Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
```

打开 `terraform-trace.log`，搜索 `[TRACE]`，然后比较：

```powershell
(Get-Content terraform-info.log).Count
(Get-Content terraform-trace.log).Count
```

日志级别按详细程度从高到低为：

```text
TRACE > DEBUG > INFO > WARN > ERROR
```

具体行数不是验收目标。TRACE 通常会包含更多 graph、state、provider protocol 和内部执行细节。

## 阶段 4：清理与验收

先确认环境变量没有遗留：

```powershell
Test-Path Env:TF_LOG
Test-Path Env:TF_LOG_PATH
```

预期都是 `False`。如果不是，运行：

```powershell
Remove-Item Env:TF_LOG -ErrorAction SilentlyContinue
Remove-Item Env:TF_LOG_PATH -ErrorAction SilentlyContinue
```

最后验收：

```powershell
terraform fmt
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

测试会读取你真实生成的两份日志，确认 INFO/TRACE 内容存在，并确认 TRACE 比 INFO 更详细。

## 安全提醒

Debug log 可能包含本地路径、provider 配置、HTTP 请求信息，甚至敏感值。提交工单或公开分享前必须检查并脱敏。日志只应在排障期间临时启用。

## 你现在应该能回答

1. `TF_LOG` 和 `TF_LOG_PATH` 各自负责什么？
2. 为什么只设置 `TF_LOG_PATH` 不会生成日志？
3. 哪个日志级别最详细？
4. 为什么生成新日志前要删除旧文件？
5. 为什么排障结束后要清除日志环境变量？
