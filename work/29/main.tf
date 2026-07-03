terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  # TODO 1：将 service_object 用 jsonencode() 编码为 JSON 字符串。
  # 提示：jsonencode 把 Terraform map/object 转为 JSON，如 jsonencode({a=1}) → "{\"a\":1}"。
  # TODO 2：用 jsondecode(file(...)) 从 data/service.json 读取并解析外部 JSON。
  # 提示：file 读取文件内容，jsondecode 把 JSON 字符串转为 Terraform map。
  # TODO 3：将 service_object.name 从 "orders" 改为 "payments"。
  # 提示：name 字段需与 data/service.json 中的一致。
  service_object = {
    name   = "payments"
    owner  = "platform"
    ports  = [8080, 9090]
    labels = { env = "dev", tier = "backend" }
  }

  encoded_service = jsonencode(local.service_object)
  decoded_service = jsondecode(file("${path.module}/data/service.json"))
}

resource "local_file" "service_json" {
  filename = "${path.module}/output/service.json"
  content  = local.encoded_service
}

output "encoded_service" {
  value = local.encoded_service
}

output "decoded_service_name" {
  value = local.decoded_service.name
}

output "decoded_skill_count" {
  value = length(local.decoded_service.skills)
}
