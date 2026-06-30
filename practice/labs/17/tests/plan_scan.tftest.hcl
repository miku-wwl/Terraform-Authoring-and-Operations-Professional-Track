variables {
  host_network_enabled = true
}

run "plan_scan_workflow_is_documented" {
  command = plan

  assert {
    condition     = contains(output.plan_scan_commands, "terraform show -json tfplan > plan.json")
    error_message = "plan level scan 必须先把二进制 plan 转成 JSON。"
  }

  assert {
    condition     = contains(output.plan_scan_commands, "checkov -f plan.json --framework terraform_plan --check CKV_K8S_19 --soft-fail")
    error_message = "plan level scan 应聚焦 CKV_K8S_19，避免全量规则噪音。"
  }
}
