run "dependency_rule_is_documented" {
  command = apply

  assert {
    condition     = strcontains(output.dependency_rule, "上游资源")
    error_message = "必须说明 target 与依赖方向的关系。"
  }

  assert {
    condition     = strcontains(output.manifest_filename, "manifest-")
    error_message = "manifest 文件名必须依赖 random_integer 的结果。"
  }
}
