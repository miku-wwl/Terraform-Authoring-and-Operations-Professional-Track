terraform {
  required_version = ">= 1.5.0"
}

variable "service_version" {
  type        = string
  description = "模拟可原地更新的服务版本。"
  default     = "1.0.0"
}

variable "deployment_generation" {
  type        = string
  description = "模拟触发替换的部署代际。"
  default     = "generation-1"
}

locals {
  desired_services = {
    api = {
      version = var.service_version
    }
  }

  # TODO 1：把替换触发信号接到 deployment_generation。
  # 提示：这个值会同时进入 input 和 triggers_replace，用来模拟 replace 行为。
  replacement_generation = "TODO-generation"

  # TODO 2：记录替换顺序策略。
  # 提示：这里应与 lifecycle 中的 create_before_destroy 对应。
  replacement_order = "TODO-replacement-order"
}

resource "terraform_data" "release_gate" {
  input = {
    generation = local.replacement_generation
  }
}

resource "terraform_data" "service" {
  # TODO 3：用 for_each 根据 desired_services 创建服务对象。
  # 提示：新增 key 表示 create，删除 key 表示 destroy。
  for_each = {}

  input = {
    name                   = each.key
    version                = each.value.version
    replacement_generation = local.replacement_generation
    replacement_order      = local.replacement_order
  }

  # TODO 4：用 triggers_replace 声明哪些值变化时需要替换资源。
  # 提示：使用 local.replacement_generation。
  triggers_replace = "TODO-replacement-trigger"

  lifecycle {
    # TODO 5：替换时先创建新对象，再销毁旧对象。
    # 提示：把这里改为 true。
    create_before_destroy = false
  }

  depends_on = [terraform_data.release_gate]
}

output "resource_behavior_model" {
  value = {
    created_services = keys(terraform_data.service)
    service_versions = {
      for name, service in terraform_data.service : name => service.output.version
    }
    replacement_generations = {
      for name, service in terraform_data.service : name => service.output.replacement_generation
    }
    replacement_triggers = {
      for name, service in terraform_data.service : name => service.triggers_replace
    }
    replacement_orders = {
      for name, service in terraform_data.service : name => service.output.replacement_order
    }
    meta_arguments = ["for_each", "depends_on", "lifecycle", "create_before_destroy"]
  }
}
