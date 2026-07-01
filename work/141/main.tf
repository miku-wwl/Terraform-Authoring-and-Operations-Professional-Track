# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_s3_bucket" "logs" {
  bucket = "tf-pro-lab-141-logs"
}

# TODO: 使用 aws_iam_policy_document 生成 bucket policy，并绑定到 bucket。
