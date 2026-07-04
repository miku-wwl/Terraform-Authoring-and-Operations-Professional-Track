run "starter_shape_is_valid" {
  command = plan

  assert {
    condition     = output.release_image_version == "v1"
    error_message = "默认 image_version 应该是 v1。"
  }
}
