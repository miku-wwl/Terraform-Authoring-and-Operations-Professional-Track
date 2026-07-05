variable "bucket" {
  description = "Bucket name supplied by the module caller."
  type        = string
}

variable "block_public_access" {
  description = "Whether the simulated bucket module should enable public access blocking."
  type        = bool
  default     = true
}
