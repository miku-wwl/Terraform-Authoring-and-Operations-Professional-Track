run "automation_commands_are_non_interactive" {
  command = plan

  assert {
    condition     = contains(output.pipeline_commands, "terraform init -input=false")
    error_message = "init 命令必须禁用交互式输入。"
  }

  assert {
    condition     = contains(output.pipeline_commands, "terraform plan -input=false -no-color -out=tfplan")
    error_message = "plan 命令必须是非交互式、无颜色输出，并保存到 plan 文件。"
  }

  assert {
    condition     = contains(output.pipeline_commands, "terraform apply -auto-approve tfplan")
    error_message = "apply 命令必须在自动化环境中使用已保存的 plan 文件。"
  }
}
