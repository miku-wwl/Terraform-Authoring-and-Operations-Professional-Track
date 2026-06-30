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
  terraform_rc = <<-EOT
  plugin_cache_dir = "/workspace/practice/labs/10/.terraform-plugin-cache"
  plugin_cache_may_break_dependency_lock_file = true
  EOT

  implementation_steps = [
    "创建 .terraform-plugin-cache 目录",
    "设置 TF_PLUGIN_CACHE_DIR 或 Terraform CLI 配置文件",
    "保留 .terraform.lock.hcl 以稳定 provider 校验和",
    "再次 terraform init 验证是否复用共享缓存",
  ]
}

resource "local_file" "terraform_rc_example" {
  filename = "${path.module}/output/terraformrc-plugin-cache.example"
  content  = local.terraform_rc
}

