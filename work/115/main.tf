# Lab 115 知识点总结：
# - debugging 是根据错误现象和详细日志逐步定位 root cause，而不是只看表面报错。
# - Terraform 默认关闭详细日志；设置 TF_LOG 后，日志会写到 stderr。
# - 日志级别按详细程度从高到低是 TRACE、DEBUG、INFO、WARN、ERROR。
# - TRACE 最详细，适合深度排查；日常不应一直开启，否则日志量会很大。
# - TF_LOG_PATH 指定日志文件；只设置 TF_LOG_PATH 不会启用日志，必须同时设置 TF_LOG。
# - 日志文件已存在时，Terraform 会追加内容，而不是自动清空旧内容。
# - 排查结束后要清除 TF_LOG 和 TF_LOG_PATH，避免污染后续 Terraform 命令。
# - debug log 可能包含路径、请求信息或其他敏感内容，不应直接提交 Git 或公开分享。
#
# 本 Lab 不需要修改下面的 Terraform 配置。学习动作是在 PowerShell 中设置环境变量、
# 运行 terraform plan，然后直接打开两份真实日志进行比较。
#
# TODO 1：初始化并观察“未开启详细日志”的普通 plan。
#
#   terraform init -input=false
#   terraform plan -input=false -no-color
#
# 此时不会自动生成 terraform-info.log 或 terraform-trace.log。
#
# TODO 2：生成 INFO 日志。
# 答案级 Hint：整段复制到 PowerShell 执行即可。
#
#   Remove-Item terraform-info.log -ErrorAction SilentlyContinue
#   $env:TF_LOG="INFO"
#   $env:TF_LOG_PATH="terraform-info.log"
#   terraform plan -input=false -no-color
#   Remove-Item Env:TF_LOG
#   Remove-Item Env:TF_LOG_PATH
#
# 打开 terraform-info.log，搜索 [INFO]。日志里通常能看到 Terraform 版本、
# backend、graph 等运行信息。TF_LOG_PATH 只是保存位置，真正开启日志的是 TF_LOG。
#
# TODO 3：生成最详细的 TRACE 日志。
# 答案级 Hint：整段复制到 PowerShell 执行即可。
#
#   Remove-Item terraform-trace.log -ErrorAction SilentlyContinue
#   $env:TF_LOG="TRACE"
#   $env:TF_LOG_PATH="terraform-trace.log"
#   terraform plan -input=false -no-color
#   Remove-Item Env:TF_LOG
#   Remove-Item Env:TF_LOG_PATH
#
# 打开 terraform-trace.log，搜索 [TRACE]。然后比较两份日志行数：
#
#   (Get-Content terraform-info.log).Count
#   (Get-Content terraform-trace.log).Count
#
# 不要求行数固定；Terraform 版本和运行环境不同，行数会变化。
# 观察重点是 TRACE 通常明显比 INFO 更详细。
#
# TODO 4：确认环境变量已清除并完成验收。
#
# Test-Path Env:TF_LOG
# Test-Path Env:TF_LOG_PATH
# terraform fmt
# terraform validate
# terraform test
#
# 两个 Test-Path 都应该返回 False，最终测试应显示：Success! 1 passed, 0 failed.
# 如果你中途停止了操作，可随时用下面两条命令清除环境变量：
#
#   Remove-Item Env:TF_LOG -ErrorAction SilentlyContinue
#   Remove-Item Env:TF_LOG_PATH -ErrorAction SilentlyContinue

terraform {
  required_version = ">= 1.5.0"
}

# 使用 Terraform 内置的 terraform_data 作为 plan 目标，不访问 AWS，也不创建云资源。
resource "terraform_data" "debug_target" {
  input = {
    lesson = "TF_LOG and TF_LOG_PATH"
    goal   = "compare INFO and TRACE logs"
  }
}

output "debug_target" {
  description = "Stable values used while generating the debug plans."
  value       = terraform_data.debug_target.input
}
