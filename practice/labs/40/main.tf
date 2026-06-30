terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "app_config" {
  filename = "${path.module}/output/app.txt"
  content  = "应用配置依赖数据库凭据文件。\n"

  lifecycle {
    precondition {
      condition     = fileexists("${path.module}/input/db.txt") && length(trimspace(file("${path.module}/input/db.txt"))) > 0
      error_message = "db.txt 必须存在且不能为空。"
    }
  }
}

output "app_config_file" {
  value = local_file.app_config.filename
}

output "db_file_is_non_empty" {
  value = length(trimspace(file("${path.module}/input/db.txt"))) > 0
}
