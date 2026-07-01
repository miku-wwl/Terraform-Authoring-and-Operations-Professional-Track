# TODO: 按 TASK.md 完成这里的 Terraform 配置。

resource "aws_vpc" "lab" {
  cidr_block = "10.132.0.0/16"

  tags = {
    Name = "tf-pro-lab-133"
  }
}

# TODO: 创建两个子网，并使用 data sources 查询它们。
