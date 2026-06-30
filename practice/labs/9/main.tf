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
  plugin_cache_dir = "${path.module}/.terraform-plugin-cache"

  cache_commands = [
    "mkdir -p .terraform-plugin-cache",
    "export TF_PLUGIN_CACHE_DIR=${local.plugin_cache_dir}",
    "terraform init -input=false",
    "terraform init -input=false",
  ]
}

resource "local_file" "cache_policy" {
  filename = "${path.module}/output/plugin-cache-policy.md"
  content = templatefile("${path.module}/templates/plugin-cache-policy.tftpl", {
    plugin_cache_dir = local.plugin_cache_dir
    cache_commands   = local.cache_commands
  })
}

