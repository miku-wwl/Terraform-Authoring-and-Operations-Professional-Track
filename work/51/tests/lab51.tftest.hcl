run "map_expressions_are_correct" {
  command = plan

  assert {
    condition = output.tags == {
      owner       = "platform"
      env         = "dev"
      cost_center = "cc-1001"
    }
    error_message = "tags 必须是包含 owner、env、cost_center 的 map。"
  }

  assert {
    condition     = output.owner_tag == "platform"
    error_message = "owner_tag 必须通过 local.tags[\"owner\"] 读取。"
  }

  assert {
    condition     = output.tag_count == 3
    error_message = "tag_count 必须通过 length(local.tags) 得到 3。"
  }

  assert {
    condition     = output.tag_keys == ["cost_center", "env", "owner"]
    error_message = "tag_keys 必须通过 keys(local.tags) 得到排序后的 key list。"
  }

  assert {
    condition     = output.service_name == "checkout"
    error_message = "service_name 必须通过 lookup(local.tags, \"service\", \"checkout\") 得到默认值。"
  }

  assert {
    condition     = output.tag_labels == ["cost_center=cc-1001", "env=dev", "owner=platform"]
    error_message = "tag_labels 必须用 for 表达式生成 key=value 标签。"
  }
}
