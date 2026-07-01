# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_iam_user" "reader" {
  name = "tf-pro-lab-135-reader"
}

# TODO: 创建只读 S3 policy，并绑定到用户。
