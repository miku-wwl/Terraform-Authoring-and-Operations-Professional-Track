terraform {
  required_version = ">= 1.5.0"
}

variable "manual_resource_id" {
  type        = string
  description = "模拟控制台中手工创建资源的 ID。"
  default     = "sg-manual-local-001"
}

locals {
  generated_config_command = "TODO：补充生成导入配置的命令"
  import_block_example = {
    to = "TODO：补充目标资源地址"
    id = var.manual_resource_id
  }
}

resource "terraform_data" "imported_security_group" {
  input = {
    id          = var.manual_resource_id
    name        = "manual-security-group"
    description = "本地模拟的手工安全组"
    ports       = [80]
  }
}

output "generated_config_command" {
  value = local.generated_config_command
}

output "import_block_example" {
  value = local.import_block_example
}

output "managed_ports" {
  value = terraform_data.imported_security_group.output.ports
}
