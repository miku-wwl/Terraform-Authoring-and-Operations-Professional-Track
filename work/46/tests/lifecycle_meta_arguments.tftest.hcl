run "starter_shape_is_valid" {
  command = plan

  assert {
    condition     = length(output.lifecycle_lab_topics) == 4
    error_message = "本实验必须覆盖四个 lifecycle meta-argument。"
  }

  assert {
    condition     = output.web_owner_tag == "terraform"
    error_message = "Owner tag 的初始值必须由 Terraform 配置为 terraform。"
  }

  assert {
    condition     = output.protected_marker_name == "tf-lab-46-protected-release"
    error_message = "protected marker 必须存在，用于观察 prevent_destroy。"
  }
}
