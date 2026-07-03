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
  # TODO 1：补充企业 CI 中使用 --skip-check 的原因。
  # 提示：不是所有规则都同等优先，高风险规则先阻断，低优先级规则按策略逐步收敛。
  checkov_scanning_notes = [
    "-f 扫描单个文件，-d 扫描整个目录",
    "--check 只运行指定规则，适合聚焦高风险检查",
    "TODO：补充企业 CI 中使用 --skip-check 的原因",
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

