output "mirror_note" {
  description = "生成的 file system mirror 说明文件。"
  value       = local_file.mirror_note.filename
}

