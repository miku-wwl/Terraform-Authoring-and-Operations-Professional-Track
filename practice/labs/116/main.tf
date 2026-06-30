terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "debug_note" {
  filename = "${path.module}/output/debug-note.txt"
  content  = "使用 TF_LOG=TRACE 和 TF_LOG_PATH=logs/terraform-debug.log 将调试日志写入文件。\n"
}

output "tf_log" {
  value = "TRACE"
}

output "tf_log_path" {
  value = "logs/terraform-debug.log"
}
