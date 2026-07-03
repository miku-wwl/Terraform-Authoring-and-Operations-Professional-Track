terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_integer" "suffix" {
  # TODO 1：补充 min 和 max，使随机整数落在 1000~9999 范围内。
  # 提示：random_integer 默认会在创建时生成一个值并写入 state，后续 plan 不改变。

}

locals {
  # TODO 2：在 artifact_name 中使用 random_integer.suffix.result，生成带随机后缀的名称。
  # 提示：用字符串插值 ${random_integer.suffix.result}。
  artifact_name = "training-artifact-TODO-random-suffix"
}

resource "local_file" "artifact" {
  filename = "${path.module}/output/${local.artifact_name}.txt"
  # TODO 3：在 content 中也输出 random_integer.suffix.result，展示它可在多处引用。
  # 提示：random_integer 的结果是稳定的——同一个 plan/apply 中多次引用得到同一个值。
  content  = "TODO：展示 random_integer 生成的值\n"
}

output "random_suffix" {
  value = random_integer.suffix.result
}

output "artifact_name" {
  value = local.artifact_name
}
