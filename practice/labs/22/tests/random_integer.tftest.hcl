run "random_suffix_is_in_expected_range" {
  command = apply

  assert {
    condition     = output.random_suffix >= 1000 && output.random_suffix <= 9999
    error_message = "random_integer 必须生成 1000 到 9999 之间的值。"
  }

  assert {
    condition     = startswith(output.artifact_name, "training-artifact-")
    error_message = "产物名必须使用随机后缀。"
  }
}
