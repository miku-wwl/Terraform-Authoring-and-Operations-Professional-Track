# Lab 114 知识点总结：
# - required_providers.version 表示“允许 Terraform 选择什么 provider 版本”。
# - .terraform.lock.hcl 表示“Terraform 上一次实际选择了什么版本”。
# - 普通 terraform init 优先复用锁文件中的版本，不会静默换成其他版本。
# - terraform init -upgrade 会忽略已有的 provider 选择，按当前约束重新选择并更新锁文件。
# - .terraform.lock.hcl 中的 hashes 用于校验 provider package，不需要手写或手动修改。
# - 锁文件跟踪 provider dependency，目前不记录 remote module 的版本选择。
# - 真实项目通常提交 .terraform.lock.hcl，但不提交本地缓存目录 .terraform/。
#
# 本 Lab 不创建资源，学习对象就是当前目录中的 .terraform.lock.hcl。
# 本节允许并要求你直接打开这个文件观察；其他 Lab 不需要照做。
#
# TODO 1：先不要改代码，观察已经锁定的 2.5.2。
# 运行：terraform init -input=false
# 然后打开 .terraform.lock.hcl，应该能看到：
#
#   version     = "2.5.2"
#   constraints = "2.5.2"
#   hashes      = [ ... ]
#
# TODO 2：把下方真正生效的版本从 2.5.2 改成 2.5.3。
# 答案级 Hint：只改这一行即可：
#
#   version = "= 2.5.3"
#
# 改完后先运行普通 init：
#
#   terraform init -input=false
#
# 这一步预期失败，不是你做错了。错误会说明锁文件选择的 2.5.2
# 不满足配置现在要求的 2.5.3，并提示使用 terraform init -upgrade。
#
# TODO 3：按照错误提示重新选择 provider：
#
#   terraform init -upgrade -input=false
#
# 再打开 .terraform.lock.hcl，最终应该看到：
#
#   version     = "2.5.3"
#   constraints = "2.5.3"
#
# TODO 4：最终验收：
#
#   terraform fmt
#   terraform validate
#   terraform test
#
# 预期结果：Success! 1 passed, 0 failed.
# 如果测试仍然看到 2.5.2，检查下面的 version 是否已经改成 2.5.3，
# 并确认运行的是 terraform init -upgrade，而不是普通 terraform init。

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source = "hashicorp/local"

      # Starter：先保留 2.5.2 完成 TODO 1。
      # TODO 2 的最终答案：version = "= 2.5.3"
      version = "= 2.5.2"
    }
  }
}
