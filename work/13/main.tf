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
  # TODO 1：补充 host_network 的安全风险说明。
  # 提示：host_network 让 Pod 共享宿主机网络命名空间，绕过 NetworkPolicy。
  security_findings = [
    "privileged 容器有逃逸风险，生产环境通常是高危配置",
    "latest 镜像标签不固定，部署不可复现，回滚困难",
    "TODO：补充 host_network 的安全风险",
  ]
}

resource "kubernetes_pod" "bad_example" {
  metadata {
    name = "static-analysis-demo"
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

