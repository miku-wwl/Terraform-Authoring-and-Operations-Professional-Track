terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
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

