terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  host     = "https://127.0.0.1:6443"
  token    = "local-plan-only"
  insecure = true
}

variable "host_network_enabled" {
  description = "是否让 Pod 使用宿主机网络。由 plan 阶段注入，用于演示源码扫描可能看不到最终值。"
  type        = bool
}

resource "kubernetes_pod" "from_variable" {
  metadata {
    name = "plan-scan-demo"
  }

  spec {
    host_network = var.host_network_enabled

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

