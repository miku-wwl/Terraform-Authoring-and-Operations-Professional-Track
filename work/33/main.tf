# Lab 33 知识点总结：
# - aws_instance 是单实例 data source，查询结果应精确匹配一台 EC2；匹配不到或匹配多台都不适合。
# - aws_instances 是多实例 data source，用来读取一组 EC2，常用返回值是 ids 列表。
# - filter block 使用 AWS EC2 API 的过滤字段名：name 表示过滤字段，values 表示允许匹配的值列表。
# - 多个 filter 之间是 AND；同一个 filter 的 values 多个值之间是 OR。
# - 按标签过滤时使用 tag:<标签名>，例如 tag:Project 匹配实例 tags 里的 Project。
# - instance-state-name 表示实例状态名称，例如 pending、running、stopped、terminated。

data "aws_instance" "production" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-33"]
  }

  filter {
    name   = "tag:Team"
    values = ["production"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
}

data "aws_instances" "all_lab" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-33"]
  }
}
