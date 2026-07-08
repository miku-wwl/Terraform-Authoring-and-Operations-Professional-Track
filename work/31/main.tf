# Lab 31 知识点总结：
# - data source 用来读取 provider 中已经存在的信息，不负责创建、修改或删除资源。
# - 它既可以读取 Terraform 已经管理的资源，也可以读取 Terraform 没有管理的外部资源。
# - resource 描述“我要管理什么”，data source 描述“我要查询什么”。
# - data block 的基本形式是：data "<TYPE>" "<NAME>" { ... }。
# - 读取结果可以通过 data.<TYPE>.<NAME>.<ATTRIBUTE> 引用。
# - data "aws_instances" 查询的是一组 EC2 实例，常用返回值是 ids。
# - filter 是 data source 的查询条件，用来缩小读取范围。

data "aws_instances" "lab" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-31"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
}
