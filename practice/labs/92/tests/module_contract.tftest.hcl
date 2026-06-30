run "module_contract" {
  command = apply

  assert {
    condition     = output.artifact_name == "lab-92"
    error_message = "模块必须输出正确的 artifact 名称。"
  }

  assert {
    condition     = strcontains(output.artifact_path, "lab-92.txt")
    error_message = "模块必须生成预期文件路径。"
  }
}

