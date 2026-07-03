terraform {
  required_version = ">= 1.5.0"
}

variable "manual_resource_id" {
  type        = string
  description = "模拟控制台中手工创建资源的 ID。"
  default     = "sg-manual-local-001"
}

locals {
  # TODO 1：补充生成导入配置的命令。
  # TODO 2：补充 import block 的目标资源地址。
  # TODO 3：补全安全组的入站端口规则（共 3 条）。
  # 提示：生成配置命令是 terraform plan -generate-config-out=generated.tf；
  # 目标地址是资源类型.资源名；端口参考 80、443、22。
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
