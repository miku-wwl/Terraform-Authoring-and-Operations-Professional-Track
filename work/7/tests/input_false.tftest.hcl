variables {
  artifact_name = "ci-artifact.txt"
}

run "commands_fail_fast_in_automation" {
  command = plan

  assert {
    condition     = contains(output.automation_commands, "terraform init -input=false")
    error_message = "init 命令必须包含 -input=false。"
  }

  assert {
    condition     = contains(output.automation_commands, "terraform plan -input=false -var artifact_name=ci-artifact.txt -out=tfplan")
    error_message = "plan 命令必须显式提供变量并禁用交互输入。"
  }
}

