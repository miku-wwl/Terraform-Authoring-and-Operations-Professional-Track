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
  # TODO 1：把 CLI 配置里的缓存目录改成 /workspace/.terraform-plugin-cache。
  # 提示：这是 terraform.rc / .terraformrc 的语法，不是 main.tf 资源配置语法。
  terraform_rc = <<-EOT
  plugin_cache_dir = "TODO：填写 provider plugin cache 目录"
  EOT

  # TODO 2：把第三步改成 lock file 相关的正确说明。
  # 提示：plugin cache 负责复用下载包，.terraform.lock.hcl 负责稳定 provider 版本和校验和。
  implementation_steps = [
    "创建 .terraform-plugin-cache 目录",
    "设置 TF_CLI_CONFIG_FILE 指向 terraform.rc，或使用默认 CLI 配置文件位置",
    "TODO：补充 lock file 与 provider 校验和的关系",
    "再次 terraform init 验证是否复用共享缓存",
  ]
}

resource "local_file" "terraform_rc_example" {
  filename = "${path.module}/output/terraformrc-plugin-cache.example"
  content  = local.terraform_rc
}
