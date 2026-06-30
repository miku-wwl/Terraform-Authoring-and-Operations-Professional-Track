terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "critical_config" {
  filename = "${path.module}/output/critical-config.txt"
  content  = "受 prevent_destroy 保护的关键配置。\n"

  lifecycle {
    prevent_destroy = true
  }
}

output "protected_resource" {
  value = "local_file.critical_config"
}

output "cleanup_command" {
  value = "terraform state rm local_file.critical_config && rm -f output/critical-config.txt"
}
