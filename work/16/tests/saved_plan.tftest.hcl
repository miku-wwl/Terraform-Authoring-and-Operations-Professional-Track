run "saved_plan_workflow_is_documented" {
  command = plan

  assert {
    condition     = contains(output.saved_plan_commands, "terraform plan -input=false -no-color -out=tfplan")
    error_message = "必须保存 plan 文件供审批和后续 apply 使用。"
  }

  assert {
    condition     = contains(output.saved_plan_commands, "terraform apply -auto-approve tfplan")
    error_message = "apply 必须使用已保存的 tfplan。"
  }
}

