run "mirror_note_is_created" {
  command = plan

  assert {
    condition     = output.mirror_note == "./output/filesystem-mirror-note.txt"
    error_message = "实验必须生成 file system mirror 说明文件。"
  }
}

