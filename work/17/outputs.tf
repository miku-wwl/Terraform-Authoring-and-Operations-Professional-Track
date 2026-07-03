output "plan_scan_commands" {
  description = "plan level scan 的核心命令。"
  value = [
    "terraform plan -input=false -no-color -out=tfplan -var host_network_enabled=true",
    "terraform show -json tfplan > plan.json",
    "checkov -f plan.json --framework terraform_plan --check CKV_K8S_19 --soft-fail",
  ]
}
