terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  critical_config_path = "${path.module}/output/critical-config.txt"
}

resource "local_file" "critical_config" {
  filename = local.critical_config_path
  content  = "critical_config=true\nowner=platform\n"

  lifecycle {
    # TODO 1: Protect this critical file from accidental Terraform destroy.
    # Hint: set prevent_destroy to true. After apply, `terraform destroy`
    # should fail, and `scripts/verify.*` checks that behavior.
    prevent_destroy = false
  }
}

output "critical_config_path" {
  description = "受保护配置文件的路径。"
  value       = local_file.critical_config.filename
}

output "protected_resource_address" {
  description = "后续 state 清理要移除的资源地址。"
  value       = "local_file.critical_config"
}
