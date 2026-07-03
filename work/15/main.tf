terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

locals {
  checkov_scanning_notes = [
    "-f 扫描单个文件，-d 扫描整个目录",
    "--check 只运行指定规则，适合聚焦高风险检查",
    "--skip-check 可按组织策略跳过低优先级规则",
  ]
}

resource "kubernetes_pod" "bad_example" {
  metadata {
    name = "checkov-options-demo"
  }

  spec {
    host_network = true

    container {
      name  = "app"
      image = "nginx:latest"

      security_context {
        privileged  = true
        run_as_user = 0
      }
    }
  }
}

