run "list_expressions_are_correct" {
  command = plan

  assert {
    condition     = output.regions == ["ap-southeast-2", "ap-southeast-1", "us-east-1"]
    error_message = "regions 必须是按题目顺序定义的三个 region 字符串。"
  }

  assert {
    condition     = output.primary_region == "ap-southeast-2"
    error_message = "primary_region 必须通过 local.regions[0] 读取第一个元素。"
  }

  assert {
    condition     = output.region_count == 3
    error_message = "region_count 必须通过 length(local.regions) 得到 3。"
  }

  assert {
    condition     = output.indexed_region_labels == ["0:ap-southeast-2", "1:ap-southeast-1", "2:us-east-1"]
    error_message = "indexed_region_labels 必须用 for 表达式生成 index:region 标签。"
  }
}
