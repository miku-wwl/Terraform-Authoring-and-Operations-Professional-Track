# Lab 116 知识点总结：
# - Lab 115 重点是比较 INFO 与 TRACE；Lab 116 重点是日志去向和环境变量的会话生命周期。
# - 只设置 TF_LOG 时，详细日志写到 stderr，因此会和正常 plan 输出一起出现在终端。
# - 同时设置 TF_LOG_PATH 后，详细日志会写入指定文件，终端主要保留正常 plan 输出。
# - TF_LOG_PATH 不会单独开启日志；必须由 TF_LOG、TF_LOG_CORE 或 TF_LOG_PROVIDER 启用日志。
# - 在 PowerShell 中用 $env:NAME="value" 设置当前进程环境变量，Terraform 子进程会继承它。
# - Remove-Item Env:NAME 会清除当前 PowerShell 会话中的环境变量。
# - 关闭终端也会丢失这种临时设置；不建议把 TRACE 永久配置为系统环境变量。
# - 日志文件存在时 Terraform 会继续追加，所以实验前应删除旧日志。
#
# 实践状态：已完成。下面保留完整操作记录，供后续复习。
#
# 已完成 1：观察没有 TF_LOG_PATH 时，INFO 日志直接出现在终端。
# 答案级 Hint：整段复制到 PowerShell 执行即可。
#
#   terraform init -input=false
#   $env:TF_LOG="INFO"
#   terraform plan -input=false -no-color
#   Remove-Item Env:TF_LOG
#
# 观察：终端除了正常 plan，还出现带 [INFO] 的日志。这些详细日志来自 stderr。
#
# 已完成 2：把 TRACE 日志改写到文件。
# 答案级 Hint：整段复制到 PowerShell 执行即可。
#
#   Remove-Item terraform-debug.log -ErrorAction SilentlyContinue
#   $env:TF_LOG="TRACE"
#   $env:TF_LOG_PATH="terraform-debug.log"
#   terraform plan -input=false -no-color
#
# 暂时不要清除环境变量。打开 terraform-debug.log，确认其中存在 [TRACE]。
# 记录当前文件大小：
#
#   $beforeCleanup = (Get-Item terraform-debug.log).Length
#
# 已完成 3：清除当前会话的日志设置，证明后续 plan 不再追加日志。
#
#   Remove-Item Env:TF_LOG
#   Remove-Item Env:TF_LOG_PATH
#   terraform plan -input=false -no-color
#   $afterCleanup = (Get-Item terraform-debug.log).Length
#   $beforeCleanup
#   $afterCleanup
#   $beforeCleanup -eq $afterCleanup
#
# 最后一条应该返回 True：环境变量清除后，普通 plan 没有继续写入 debug log。
# 再确认环境变量不存在：
#
#   Test-Path Env:TF_LOG
#   Test-Path Env:TF_LOG_PATH
#
# 两条都应该返回 False。
#
# 已完成 4：最终验收。
#
#   terraform fmt
#   terraform validate
#   terraform test
#
# 预期结果：Success! 1 passed, 0 failed.
#
# 其他 shell 的临时设置与清理语法（只需认识，不要求在本机执行）：
#
# Windows CMD：
#   set TF_LOG=TRACE
#   set TF_LOG_PATH=terraform-debug.log
#   set TF_LOG=
#   set TF_LOG_PATH=
#
# Linux / macOS：
#   export TF_LOG=TRACE
#   export TF_LOG_PATH=terraform-debug.log
#   unset TF_LOG
#   unset TF_LOG_PATH
#
# 如果中途停止，PowerShell 兜底清理命令：
#   Remove-Item Env:TF_LOG -ErrorAction SilentlyContinue
#   Remove-Item Env:TF_LOG_PATH -ErrorAction SilentlyContinue

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.3"
    }
  }
}

# 与原课程相同，使用一个简单的本地文件作为 plan 目标。
# 本 Lab 不执行 apply，因此 debug-target.txt 不会真的被创建。
resource "local_file" "debug_target" {
  filename = "${path.module}/debug-target.txt"
  content  = "Lab 116: temporary debug environment variables\n"
}

output "session_demo" {
  description = "Stable values used by the logging session experiment."
  value = {
    lesson = "temporary debug environment variables"
    shell  = "PowerShell"
  }
}
