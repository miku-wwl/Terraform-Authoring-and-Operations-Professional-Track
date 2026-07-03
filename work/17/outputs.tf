# TODO 1：补充把二进制 plan 转成 JSON 的命令。
# TODO 2：补充针对 plan.json 的 Checkov plan scan 命令。
# 提示：terraform show -json tfplan > plan.json 转换格式；
# checkov -f plan.json --framework terraform_plan --check CKV_K8S_19 --soft-fail 扫描 plan。
output "plan_scan_commands" {
  description = "plan level scan 的核心命令。"
  value = [
    "terraform plan -input=false -no-color -out=tfplan -var host_network_enabled=true",
    "TODO：补充把二进制 plan 转成 JSON 的命令",
    "TODO：补充针对 plan.json 的 Checkov plan scan 命令",
  ]
}
