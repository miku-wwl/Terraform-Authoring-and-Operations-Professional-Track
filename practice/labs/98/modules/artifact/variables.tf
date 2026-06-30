variable "name" {
  type        = string
  description = "产物名称。"
}

variable "content" {
  type        = string
  description = "产物内容。"
  default     = "module managed content"
}
