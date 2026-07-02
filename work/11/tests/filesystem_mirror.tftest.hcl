run "mirror_note_is_created" {
  command = plan

  assert {
    condition     = strcontains(output.cli_config_content, "filesystem_mirror")
    error_message = "CLI 配置必须包含 provider_installation.filesystem_mirror。"
  }

  assert {
    condition     = strcontains(output.cli_config_content, "path    = \"/workspace/mirror\"")
    error_message = "filesystem_mirror.path 必须指向容器内的 /workspace/mirror。"
  }

  assert {
    condition     = strcontains(output.cli_config_content, "direct")
    error_message = "CLI 配置需要包含 direct 规则，用来说明是否允许回退公网安装。"
  }

  assert {
    condition     = output.mirror_note == "./output/filesystem-mirror-note.txt"
    error_message = "实验必须生成 file system mirror 说明文件。"
  }

  assert {
    condition     = !strcontains(output.cli_config_content, "TODO")
    error_message = "terraform-cli.rc 中不能保留 TODO。"
  }
}
