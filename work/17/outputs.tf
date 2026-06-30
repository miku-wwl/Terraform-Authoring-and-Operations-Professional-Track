output "plan_scan_commands" {
  description = "plan level scan 的核心命令。"
  value = [
    "terraform plan -input=false -no-color -out=tfplan -var host_network_enabled=true",
    "TODO：补充把二进制 plan 转成 JSON 的命令",
    "TODO：补充针对 plan.json 的 Checkov plan scan 命令",
  ]
}
