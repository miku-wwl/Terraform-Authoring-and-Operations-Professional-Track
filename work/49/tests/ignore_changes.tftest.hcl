run "starter_shape_is_valid" {
  command = plan

  assert {
    condition     = output.externally_managed_tag_key == "Owner"
    error_message = "本实验必须把 Owner tag 作为外部系统管理的 drift 目标。"
  }

  assert {
    condition     = output.configured_owner_tag == "terraform"
    error_message = "Terraform 配置中的 Owner tag 初始值必须是 terraform。"
  }
}
