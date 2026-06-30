variable "artifact_name" {
  description = "自动化环境必须显式提供的产物文件名。"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]+\\.txt$", var.artifact_name))
    error_message = "artifact_name 必须是小写字母或数字开头的 txt 文件名。"
  }
}

