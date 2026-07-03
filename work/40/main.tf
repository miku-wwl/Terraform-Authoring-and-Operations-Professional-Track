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
    # TODO 1：补全 precondition，检查 input/db.txt 存在且内容非空。
    # 提示：用 fileexists 检查文件存在，用 file + trimspace 检查非空。
    precondition {
      condition     = true
      error_message = "db.txt 必须存在且不能为空。"
    }
  }
}

output "app_config_file" {
  value = local_file.app_config.filename
}

# TODO 2：补全 db_file_is_non_empty 的表达式，使其在文件非空时返回 true。
# 提示：用 length(trimspace(file(...))) > 0 判断 db.txt 是否非空。
output "db_file_is_non_empty" {
  value = false
}
