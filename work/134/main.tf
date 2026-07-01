# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_iam_user" "operator" {
  name = "tf-pro-lab-134-operator"
}

# TODO: 创建 login profile、access key，并把敏感输出标记为 sensitive。
