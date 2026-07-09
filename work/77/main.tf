terraform {
  required_version = ">= 1.12.0"
}

# Lab 77 知识点总结：
# - 本实验在 S3 remote backend 上练习 Terraform state 管理命令。
# - terraform state list 用来列出当前 state 中记录的资源地址。
# - terraform state show <address> 用来查看某个资源在 state 中保存的详细属性。
# - terraform state pull 会从 backend 拉取完整 state JSON，适合只读检查，不要手工编辑后再塞回去。
# - remote backend 改变的是 state 存放位置；state 命令仍然通过 Terraform CLI 访问当前 backend。
# - terraform_data 是 Terraform 内置资源，适合在实验中创建一个轻量对象来观察 state 内容。

resource "terraform_data" "state_audit" {
  input = {
    lab   = "77"
    topic = "Terraform State 管理命令"
  }
}
