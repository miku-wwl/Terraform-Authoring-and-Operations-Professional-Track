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
  security_findings = [
    "privileged 容器有逃逸风险，生产环境通常是高危配置",
    "latest 镜像标签不固定，部署不可复现，回滚困难",
    "host_network 共享宿主机网络，绕过 NetworkPolicy",
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

